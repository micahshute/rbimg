class Rbimg::PNG

    
    REQUIRED_CHUNKS = [
        :IHDR,
        :IDAT,
        :IEND
    ]

    COLOR_TYPES = {
        greyscale: 0,
        rgb: 2,
        pallet: 3,
        greyscale_alpha: 4,
        rgba: 6
    }

    def self.combine(*images, divider: nil, as: :row) 
        raise ArgumentError.new("as: must be :row or :col") if as != :row && as != :col 
        raise ArgumentError.new("Images and divider must all be an Rbimg::PNG") if !images.all?{|i| i.is_a?(Rbimg::PNG)} 
        type = images.first.type
        height = images.first.height
        width = images.first.width
        bit_depth = images.first.bit_depth

        color_type = COLOR_TYPES[type]

        logical_pixel_width = width * Rbimg::PNG.pixel_size_for(color_type: color_type)

        if divider
            width_multiplier = logical_pixel_width / width
            divider_width = divider.width * width_multiplier
            if as == :row
                raise ArgumentError.new("divider must have the same height as images if aligning as a row") if divider.height != height
            elsif as == :col
                raise ArgumentError.new("divider must have the same width as images if aligning as a column") if divider.width != width
            end
            raise ArgumentError.new("divider must have the same type and bit_depth as images") if divider.type != type || divider.bit_depth != bit_depth
        end

        images.each do |i|
            if i.type != type || i.height != height || i.width != width || i.bit_depth != bit_depth
                raise ArgumentError.new("Currently all images must have the same type, height, width, and bit_depth to be combined")
            end
        end


        if as == :row
            new_width = images.length * width 
            new_height = height
            
            if divider
                new_width += (divider.width * (images.length - 1))
            end

            new_pixels = height.times.map do |row|
                row_start = row * logical_pixel_width
                divider_row_start = row * divider_width if divider
                images.map do |img|
                    row_pixels = img.pixels[row_start...(row_start + logical_pixel_width)] 
                    ((img == images.last) || divider.nil?) ? row_pixels : row_pixels + divider.pixels[divider_row_start...(divider_row_start + divider_width)]
                end
            end.flatten
        
        else
            new_width = width
            new_height = images.length * height
            if divider
                new_height += (divider.height * (images.length - 1))
            end

            new_pixels = images.map do |img|
                img_pixels = img.pixels
                if divider && img != images.last
                    img_pixels + divider.pixels
                else
                    img_pixels
                end
            end.flatten
        end

        begin
        new_img = Rbimg::PNG.new(pixels: new_pixels, type: type, width: new_width, height: new_height, bit_depth: bit_depth)
        rescue
            binding.pry
        end

    end

    def self.pixel_size_for(color_type:)
        case color_type
        when 0
            1
        when 2
            3
        when 3
            1
        when 4
            2
        when 6
            4
        else
            raise ArgumentError.new("#{color_type} is not a valid color type. Must be 0,2,3,4, or 6")
        end
    end

    def self.read(path: nil, data: nil)
        
        raise ArgumentError.new(".read must be initialized with a path or a datastream") if (path.nil? && data.nil?) || (!path.nil? && !data.nil?)
        raise ArgumentError.new("data must be an array of byte integers or a byte string") if data && !data.is_a?(Array) && !data.is_a?(String)
        raise ArgumentError.new("data must be an array of byte integers or a byte string") if data && data.is_a?(Array) && !data.first.is_a?(Integer) 
        path += ".png" if path && !path.end_with?('.png')
        begin

            if path
                data = File.read(path).bytes
            else
                data = data.bytes if data.is_a?(String)
            end
            
            chunk_start = 8
            chunks = []
            loop do 
                len_end = chunk_start + 4
                type_end = len_end + 4
                len = Byteman.buf2int(data[chunk_start...len_end])
                type = data[len_end...type_end]
                chunk_end = type_end + len + 4
                case type.pack("C*")
                when "IHDR"
                    chunks << Chunk.readIHDR(data[chunk_start...chunk_end])
                when "IDAT"
                    chunks << Chunk.readIDAT(data[chunk_start...chunk_end])
                when "PLTE"
                    chunks << Chunk.readPLTE(data[chunk_start...chunk_end])
                else
                    chunks << data[chunk_start...chunk_end]
                end

                chunk_start = chunk_end
                #TODO: Make sure last chunk is IEND
                break if chunk_end >= data.length - 1

            end

            width = chunks.first[:width]
            height = chunks.first[:height]
            bit_depth = chunks.first[:bit_depth]
            color_type = chunks.first[:color_type]
            compression_method = chunks.first[:compression_method]
            filter_method = chunks.first[:filter_method]
            interlace_method = chunks.first[:interlace_method]

            all_idats = chunks.filter{ |c| c.is_a?(Hash) && c[:type] == "IDAT" }
            compressed_pixels = all_idats.reduce([]) { |mem, idat| mem + idat[:compressed_pixels] }
            pixels_and_filter = Zlib::Inflate.inflate(compressed_pixels.pack("C*")).unpack("C*")
            

            logical_pixel_width = Rbimg::PNG.pixel_size_for(color_type: color_type) * width

            pixel_width = (logical_pixel_width * (bit_depth / 8.0)).ceil


            scanline_filters = Array.new(height, nil)
            pixels = Array.new(pixels_and_filter.length - height, nil)
            
            pixels_and_filter.each.with_index do |pixel,i| 
                scanline = i / (pixel_width + 1)
                pixel_number = (i % (pixel_width + 1)) - 1
                pixel_loc = scanline * pixel_width + pixel_number
                if (pixel_number == -1)
                    scanline_filters[scanline] = pixel
                else
                    case scanline_filters[scanline]
                    when 0
                        pixels[pixel_loc] = pixel
                    when 1
                        x = pixel_number
                        bpp = (pixel_width / width) * (bit_depth / 8.0).ceil
                        prev_raw = x - bpp < 0 ? 0 : pixels[pixel_loc - bpp]
                        new_pixel = (pixel + prev_raw) % 256
                        pixels[pixel_loc] = new_pixel
                    when 2
                        x = pixel_number
                        prev_raw = scanline == 0 ? 0 : pixels[pixel_loc - pixel_width]
                        new_pixel = (pixel + prev_raw) % 256
                        pixels[pixel_loc] = new_pixel
                    when 3
                        x = pixel_number
                        bpp = (pixel_width / width) * (bit_depth / 8.0).ceil
                        left_pix = x - bpp < 0 ? 0 : pixels[pixel_loc - bpp]
                        above_pix = scanline == 0 ? 0 : pixels[pixel_loc - pixel_width]
                        new_pixel = (pixel + ((left_pix + above_pix) / 2).floor) % 256
                        pixels[pixel_loc] = new_pixel
                    when 4
                        x = pixel_number
                        bpp = (pixel_width / width) * (bit_depth / 8.0).ceil

                        paeth_predictor = Proc.new do |left, above, upper_left|
                            p = left + above - upper_left
                            pa = (p - left).abs
                            pb = (p - above).abs
                            pc = (p - upper_left).abs
                            if pa <= pb && pa <= pc
                                left
                            elsif pb <= pc
                                above
                            else
                                upper_left
                            end
                        end

                        left_pix = x - bpp < 0 ? 0 : pixels[pixel_loc - bpp]
                        above_pix = scanline == 0 ? 0 : pixels[pixel_loc - pixel_width]
                        upper_left_pix = scanline == 0 ? 0 : x - bpp < 0 ? 0 : pixels[pixel_loc - pixel_width - bpp]
                        pp_out = paeth_predictor[left_pix, above_pix, upper_left_pix]
                        new_pixel = (pixel + pp_out) % 256
                        pixels[pixel_loc] = new_pixel
                    else
                        raise Rbimg::FormatError.new("Incorrect Filtering type used on this PNG file")
                    end
                end
            end


            

            if bit_depth != 8
                corrected_pixels = Array.new(logical_pixel_width * height, nil)
                height.times do |row_num| 
                    row_start = row_num * pixel_width
                    row_end = row_start + pixel_width
                    row_data = pixels[row_start...row_end]
                    binary_data = Byteman.buf2int(row_data).to_s(2)
                    pad_size = ((logical_pixel_width * bit_depth) / 8.0).ceil * 8
                    binary_data = Byteman.pad(num: binary_data, len: pad_size, type: :bits)
                    corrected_row_start = row_num * logical_pixel_width
                    logical_pixel_width.times do |pixel_num_in_row|
                        binary_segment_start = pixel_num_in_row * bit_depth
                        binary_segment_end = binary_segment_start + bit_depth
                        binary_segment = binary_data[binary_segment_start...binary_segment_end]
                        logical_pixel_value = binary_segment.to_i(2)
                        corrected_pixel_location = corrected_row_start + pixel_num_in_row
                        corrected_pixels[corrected_pixel_location] = logical_pixel_value
                    end
                end
            else
                corrected_pixels = pixels
            end

            args = {pixels: corrected_pixels, type: color_type, width: width, height: height, bit_depth: bit_depth}
            plte = chunks.find{|c| c[:type] == "PLTE" unless c.is_a?(Array)}
            args[:palette] = plte[:chunk_data] if plte
            new(**args)
        rescue Errno::ENOENT => e
            raise ArgumentError.new("Invalid path #{path}")
        rescue => e
            raise e if e.is_a?(Rbimg::FormatError)
            raise Rbimg::FormatError.new("This PNG file is not in the correct format or has been corrupted :)")
        end
    end


    
    attr_reader :pixels, :width, :height, :bit_depth, :compression_method, :filter_method, :interlace_method
    attr_reader :pixel_size
    def initialize(pixels: nil, type: nil, width: nil, height: nil, bit_depth: 8, compression_method: 0, filter_method: 0, interlace_method: 0, palette: nil)
        @pixels, @width, @height, @compression_method, @filter_method, @interlace_method = pixels, width, height, compression_method, filter_method, interlace_method
        @bit_depth = bit_depth
        type = :greyscale if type.nil?

        @type = type.is_a?(Integer) ? type : COLOR_TYPES[type]
        raise ArgumentError.new("#{type} is not a valid color type. Please use one of: #{COLOR_TYPES.keys}") if type.nil?
        raise ArgumentError.new("Palettes are not compatible with color types 0 and 4") if palette && (@type == 0 || @type == 4)
        raise ArgumentError.new("palette must be an array") if palette && !palette.is_a?(Array)
        @signature = [137, 80, 78, 71, 13, 10, 26, 10]
        @chunks = [
            Chunk.IHDR(
                width: @width, 
                height: @height, 
                bit_depth: @bit_depth, 
                color_type: @type, 
                compression_method: @compression_method, 
                filter_method: @filter_method, 
                interlace_method: interlace_method
            ),
            *Chunk.IDATs(
                pixels, 
                color_type: @type, 
                bit_depth: @bit_depth, 
                width: @width, 
                height: @height
            ),
            Chunk.IEND
        ]
        @chunks.insert(1, Chunk.PLTE(palette)) if !palette.nil?

        @pixel_size = Rbimg::PNG.pixel_size_for(color_type: @type)

    end

    def pixel(num)
        start = num * @pixel_size
        pend = start + @pixel_size
        pixels[start...pend]
    end

    def row(rownum)
        return nil if rownum > self.height
        pix_width = pixel_size * width
        start = rownum * pix_width
        pend = start + pix_width
        pixels[start...pend]
    end


    def type
        COLOR_TYPES.each do |k,v|
            return k if v == @type
        end
    end

    def bytes
        all_data.pack("C*")
    end

    def write(path: Dir.pwd + "/output.png")
        postscript = path.split(".").last == "png" ? "" : ".png"
        File.write(path + postscript, bytes)
    end



    private

    def all_data 
        @signature + @chunks.map(&:data).flatten 
    end

    class Chunk

        def self.readChunk(bytes)
            bytes = bytes.bytes if bytes.is_a?(String)
            data = {}
            data[:length] = Byteman.buf2int(bytes[0...4])
            data[:type] = Byteman.buf2hex(bytes[4...8])
            data[:crc] = bytes[-4..-1]
            data[:chunk_data] = bytes[8...(8 + data[:length])]
            raise Rbimg::CRCError.new("CRC does not match expected") if !crc_valid?(type: data[:type].unpack("C*"), data: data[:chunk_data], crc: data[:crc])
            data
        end

        def self.readIHDR(bytes)
            bytes = bytes.bytes if bytes.is_a?(String)
            raise ArgumentError.new("IHDR must be 25 bytes long") if bytes.length != 25
 
            data = readChunk(bytes)
            data[:width] = Byteman.buf2int(bytes[8...12])
            data[:height] = Byteman.buf2int(bytes[12...16])
            data[:bit_depth] = bytes[16]
            data[:color_type] = bytes[17]
            data[:compression_method] = bytes[18]
            data[:filter_method] = bytes[19]
            data[:interlace_method] = bytes[20]
            data
        end

        def self.readIDAT(bytes)
            data = readChunk(bytes)
            data[:compressed_pixels] = data[:chunk_data]
            data
        end

        def self.readPLTE(bytes)
            readChunk(bytes)
        end

        def self.crc_valid?(type:, data:, crc:)
            c = new(type: type, data: data)
            c.bytes[-4..-1].bytes == crc
        end

        def self.IHDR(width: , height: , bit_depth: , color_type: , compression_method: 0, filter_method: 0, interlace_method: 0)
            bit_depth_rules = {
                0 => [1,2,4,8,16],
                2 => [8, 16],
                3 => [1,2,4,8],
                4 => [8,16],
                6 => [8,16]
            }

            raise ArgumentError.new("Width or height cannot be 0") if width == 0 || height == 0
            test_length(width)
            test_length(height) 
            raise ArgumentError.new('Color code types must be 0, 2, 3, 4, or 6') if ![0,2,3,4,6].include?(color_type)
            raise ArgumentError.new("Bit depth must be related to color_type as such: color_value => bit_depth_options: #{bit_depth_rules}") if !bit_depth_rules[color_type].include?(bit_depth) 


            wbytes = Byteman.pad(len: 4, num: Byteman.int2buf(width))
            hbytes = Byteman.pad(len: 4, num: Byteman.int2buf(height))
            bdbyte = [bit_depth]
            ctbyte = [color_type]
            cmbyte = [compression_method]
            fmbyte = [filter_method]
            ilmbyte = [interlace_method]
            data = wbytes + hbytes + bdbyte + ctbyte + cmbyte + fmbyte + ilmbyte
            Chunk.new(type: "IHDR", data: data) 
        end

        def self.PLTE(data)
            data = data.bytes if data.is_a?(String)
            raise ArgumentError.new("Number of bytes must be a multiple of 3") if data.length % 3 != 0
            raise ArgumentError.new("Pallette length must be between 1 and 256") if data.length < 3 || data.length > (256 * 3)
            Chunk.new(type: "PLTE", data: data)
        end

        def self.IDATs(pixels, color_type: ,bit_depth:, width: , height: , idat_size: 2 ** 20)

            case color_type
            when 0
                pixel_width = width
            when 2
                pixel_width = width * 3
            when 3
                pixel_width = width 
            when 4
                pixel_width = width * 2
            when 6
                pixel_width = width * 4
            else
                raise ArgumentError.new("#{color_type} is not a valid color type. Must be 0,2,3,4, or 6")
            end
            expected_pixels = pixel_width * height
            raise ArgumentError.new("pixel count (#{pixels.length}) does not match expected pixel count (#{expected_pixels})") if pixels.length != expected_pixels
            pixel_square = Array.new(height, nil)
            pixel_square = pixel_square.map{ |_| [nil] * pixel_width}
            for i in 0...pixels.length
                row = i / pixel_width
                col = i % pixel_width
                pixel_square[row][col] = pixels[i]
            end

            scanlines = pixel_square.map do |bit_strm|

                case bit_depth
                when 1
                    raise ArgumentError.new("If bit depth is 1, all pixel values must be a 1 or 0") if bit_strm.any?{ |b| b != 0 && b != 1 }
                    bits = bit_strm.join('') + ("0" * ((-1 * bit_strm.length % 8) % 8 ))
                    Byteman.hex(0) + Byteman.pad(num: Byteman.hex(bits.to_i(2)), len: bits.length / 8)
                when 2
                    bits = bit_strm.map do |b| 
                        raise ArgumentError.new("If bit depth is 2, all pixel values must be between 0 and 3") if !b.between?(0,3)
                        Byteman.pad(num: b, len: 2, type: :bits)
                    end.join('')
                    padded_bits = bits + ("0" * ((-1 * bit_strm.length * 2) % 8) % 8)
                    Byteman.hex(0) + Byteman.pad(num: Byteman.hex(padded_bits.to_i(2)), len: padded_bits.length / 8)
                when 4       
                    bits = bit_strm.map do |b|
                        raise ArgumentError.new("If bit depth is 4, all pixel values must be between 0 and 15") if !b.between?(0,15)
                        Byteman.pad(num: b, len: 4, type: :bits)
                    end.join('')
                    padded_bits = bits + ("0" * ((-1 * bit_strm.length * 4) % 8) % 8)
                    Byteman.hex(0) + Byteman.pad(num: Byteman.hex(padded_bits.to_i(2)), len: padded_bits.length / 8)
                when 8
                    raise ArgumentError.new("If bit depth is 8, all pixel values must be between 0 and 255") if bit_strm.any?{|b| !b.between?(0,255)}
                    ([0] + bit_strm).pack("C*")
                when 16
                    raise ArgumentError.new("If bit depth is 16, all pixel values must be between 0 and 65535") if bit_strm.any?{|b| !b.between?(0,65535)}
                    Byteman.hex(0) + bit_strm.map{|b| Byteman.pad(num: Byteman.hex(b), len: 2)}.join('')
                else
                    ArgumentError.new("bit_depth can only be 1,2,4,8, or 16 bits")
                end

            end
            
            z = Zlib::Deflate.new(Zlib::BEST_COMPRESSION, Zlib::MAX_WBITS, Zlib::MAX_MEM_LEVEL, Zlib::RLE)
            zstrm = z.deflate(scanlines.join(''), Zlib::FINISH)
            z.close
            idats = []
            zstrm.bytes.each_slice(idat_size) do |dstrm|
                idats << Chunk.new(type: "IDAT", data: dstrm)
            end
            
            idats
        end 

        def self.IEND
            Chunk.new(type: "IEND", data: nil)
        end
       

        attr_reader :length, :type, :data

        def initialize(type: ,data:)
            raise ArgumentError.new("Type must be a string, symbol, or an array") if !type.is_a?(String) && !type.is_a?(Symbol) && !type.is_a?(Array)
            @data = data.nil? ? [] : data
            @length = Byteman.pad(len: 4, num: Byteman.int2buf(@data.length))
            self.class.test_length(@data.length)
 
            if type.is_a?(String) || type.is_a?(Symbol)
                @type = type.to_s.bytes
            else
                @type = type
            end
            @crc_strategy = Rbimg::Strategies::CRCTableLookup
            @crc = crc
        end

        def data
            @length + @type + @data + @crc
        end

        def bytes
            data.pack("C*")
        end 

        private


        def self.test_length(num, limit: 2 ** 31 - 1)
            raise ArgumentError.new("Length cannot exceed 2^31 - 1") if num > limit
        end


        def crc
            @crc_strategy.crc(@type, @data)
        end

    end

     
    

end