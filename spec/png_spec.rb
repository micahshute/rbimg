RSpec.describe Rbimg::PNG do 

  it "can read a valid pallet PNG img" do 
    png = Rbimg::PNG.read(path: './data/palette.png')
    expect(png).to be_a(Rbimg::PNG)
  end

  it "can read and write a pallet PNG img" do
    png = Rbimg::PNG.read(path: './data/palette.png')
    if File.exist?(Dir.pwd + '/palette.png')
      File.delete('./palette.png')
    end
    png.write(path: "./palette.png")
    expect(File.exist?(Dir.pwd + '/palette.png')).to eq(true)
    png2 = Rbimg::PNG.read(path: './palette.png')
    expect(png.pixels).to eq(png2.pixels)
  end

  it "can read and  write a greyscale image with bit depth of 1" do 
    width = 987
    height = 833
    r = Random.new
    pixels = Array.new(width * height) do 
      r.rand(2)
    end
    png = Rbimg::PNG.new(pixels: pixels, type: :greyscale, width: width, height: height, bit_depth: 1)
    if File.exist?(Dir.pwd + '/grey_bitdepth_1.png')
      File.delete('./grey_bitdepth_1.png')
    end
    png.write(path: './grey_bitdepth_1')
    expect(File.exist?(Dir.pwd + '/grey_bitdepth_1.png')).to eq(true)

    png2 = Rbimg::PNG.read(path: './grey_bitdepth_1.png')
    if File.exist?(Dir.pwd + '/grey_bitdepth_1_rewrite.png')
      File.delete('./grey_bitdepth_1_rewrite.png')
    end

    png2.write(path: './grey_bitdepth_1_rewrite')
    expect(File.exist?(Dir.pwd + '/grey_bitdepth_1_rewrite.png')).to eq(true)
    expect(png.pixels).to eq(png2.pixels)

    pixels2 = [0,0,0,0,1,1,0,0,0,1,0,0]
    png3 = Rbimg::PNG.new(pixels: pixels2, type: :greyscale, width: 3, height: 4, bit_depth: 1)
    if File.exist?(Dir.pwd + '/test_1byte.png')
      File.delete('./test_1byte.png')
    end
    png3.write(path: "./test_1byte")
    png4 = Rbimg::PNG.read(path: './test_1byte')
    png4.write(path: './test_1byte_rewrite')
    expect(File.exist?(Dir.pwd + '/test_1byte.png')).to eq(true)
    expect(png3.pixels).to eq(png4.pixels)
  end

  it "can read and  write a greyscale image with bit depth of 2" do 
    width = 1023
    height = 833
    r = Random.new
    pixels = Array.new(width * height) do 
      r.rand(2 ** 2)
    end
    png = Rbimg::PNG.new(pixels: pixels, type: :greyscale, width: width, height: height, bit_depth: 2)
    if File.exist?(Dir.pwd + '/grey_bitdepth_2.png')
      File.delete('./grey_bitdepth_2.png')
    end
    png.write(path: './grey_bitdepth_2')
    expect(File.exist?(Dir.pwd + '/grey_bitdepth_2.png')).to eq(true)

    png2 = Rbimg::PNG.read(path: './grey_bitdepth_2.png')
    if File.exist?(Dir.pwd + '/grey_bitdepth_2_rewrite.png')
      File.delete('./grey_bitdepth_2_rewrite.png')
    end

    png2.write(path: './grey_bitdepth_2_rewrite')
    expect(File.exist?(Dir.pwd + '/grey_bitdepth_2_rewrite.png')).to eq(true)
    expect(png.pixels).to eq(png2.pixels)

    pixels2 = [0,0,0,0,3,2,0,0,0,1,0,0]
    png3 = Rbimg::PNG.new(pixels: pixels2, type: :greyscale, width: 3, height: 4, bit_depth: 2)
    if File.exist?(Dir.pwd + '/test_2byte.png')
      File.delete('./test_2byte.png')
    end
    png3.write(path: "./test_2byte")
    png4 = Rbimg::PNG.read(path: './test_2byte')
    png4.write(path: './test_2byte_rewrite')
    expect(File.exist?(Dir.pwd + '/test_2byte.png')).to eq(true)
    expect(png3.pixels).to eq(png4.pixels)
  end

  it "can read and write an image with bit depth of 4" do 
    r = Random.new
    width = 1023
    height = 83
    pixels = Array.new(width * height) do 
      r.rand(2 ** 4)
    end
    png = Rbimg::PNG.new(pixels: pixels, type: :greyscale, width: width, height: height, bit_depth: 4)
    if File.exist?(Dir.pwd + '/grey_bitdepth_4.png')
      File.delete('./grey_bitdepth_4.png')
    end
    png.write(path: './grey_bitdepth_4')
    expect(File.exist?(Dir.pwd + '/grey_bitdepth_4.png')).to eq(true)

    png2 = Rbimg::PNG.read(path: './grey_bitdepth_4.png')
    if File.exist?(Dir.pwd + '/grey_bitdepth_4_rewrite.png')
      File.delete('./grey_bitdepth_4_rewrite.png')
    end

    png2.write(path: './grey_bitdepth_4_rewrite')
    expect(File.exist?(Dir.pwd + '/grey_bitdepth_4_rewrite.png')).to eq(true)
    expect(png.pixels).to eq(png2.pixels)

    pixels2 = [0,0,0,0,10,10,0,0,0,15,0,0]
    png3 = Rbimg::PNG.new(pixels: pixels2, type: :greyscale, width: 3, height: 4, bit_depth: 4)
    if File.exist?(Dir.pwd + '/test_4byte.png')
      File.delete('./test_4byte.png')
    end
    png3.write(path: "./test_4byte")
    png4 = Rbimg::PNG.read(path: './test_4byte')
    png4.write(path: './test_4byte_rewrite')
    expect(File.exist?(Dir.pwd + '/test_4byte.png')).to eq(true)
    expect(png3.pixels).to eq(png4.pixels)


  end

  it "can read and write an image with a bit depth of 16" do
    height = 140
    width = 123
    r = Random.new

    pixels = Array.new(3 * width * height) do |i|
      r.rand(2 ** 16)
      
    end

    png = Rbimg::PNG.new(pixels: pixels, type: :rgb, width: width, height: height, bit_depth: 16)
    if File.exist?(Dir.pwd + '/rgb_bitdepth_16.png')
      File.delete('./rgb_bitdepth_16.png')
    end
    png.write(path: './rgb_bitdepth_16')
    expect(File.exist?(Dir.pwd + '/rgb_bitdepth_16.png')).to eq(true)

    png2 = Rbimg::PNG.read(path: './rgb_bitdepth_16.png')
    if File.exist?(Dir.pwd + '/rgb_bitdepth_16_rewrite.png')
      File.delete('./rgb_bitdepth_16_rewrite.png')
    end

    png2.write(path: './rgb_bitdepth_16_rewrite')
    expect(File.exist?(Dir.pwd + '/rgb_bitdepth_16_rewrite.png')).to eq(true)

    expect(png.pixels).to eq(png2.pixels)

    pixels2 = [0,0,0,0,0,0,0,0,0,2 ** 15, 0, 2 ** 15, 0, 2 ** 15, 2 ** 15, 2 ** 15, 2 ** 15, 0, 0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1]

    png3 = Rbimg::PNG.new(pixels: pixels2, type: :rgb, width: 3, height: 4, bit_depth: 16)
    if File.exist?(Dir.pwd + '/testrgb_bitdepth_16.png')
      File.delete('./testrgb_bitdepth_16.png')
    end
    png3.write(path: './testrgb_bitdepth_16')
    expect(File.exist?(Dir.pwd + '/testrgb_bitdepth_16.png')).to eq(true)

    png4 = Rbimg::PNG.read(path: './testrgb_bitdepth_16.png')
    if File.exist?(Dir.pwd + '/testrgb_bitdepth_16_rewrite.png')
      File.delete('./testrgb_bitdepth_16_rewrite.png')
    end

    png4.write(path: './testrgb_bitdepth_16_rewrite')
    expect(File.exist?(Dir.pwd + '/testrgb_bitdepth_16_rewrite.png')).to eq(true)

    expect(png.pixels).to eq(png2.pixels)

    pixels3 = Array.new(4 * width * height) do |i|
      r.rand(2 ** 16)
      
    end

    png5 = Rbimg::PNG.new(pixels: pixels3, type: :rgba, width: width, height: height, bit_depth: 16)
    if File.exist?(Dir.pwd + '/rgba_bitdepth_16.png')
      File.delete('./rgba_bitdepth_16.png')
    end
    png5.write(path: './rgba_bitdepth_16')
    expect(File.exist?(Dir.pwd + '/rgba_bitdepth_16.png')).to eq(true)

    png6 = Rbimg::PNG.read(path: './rgba_bitdepth_16.png')
    if File.exist?(Dir.pwd + '/rgba_bitdepth_16_rewrite.png')
      File.delete('./rgba_bitdepth_16_rewrite.png')
    end

    png6.write(path: './rgba_bitdepth_16_rewrite')
    expect(File.exist?(Dir.pwd + '/rgba_bitdepth_16_rewrite.png')).to eq(true)

    expect(png5.pixels).to eq(png6.pixels)
    
  end

  it "appropriately reads images with different scanline filtering methods" do 
    png1 = Rbimg::PNG.read(path: './data/filter_test1')
    png2 = Rbimg::PNG.read(path: './data/filter_test2')
    if File.exist?(Dir.pwd + '/filter_test1_rewrite.png')
      File.delete('./filter_test1_rewrite.png')
    end
    if File.exist?(Dir.pwd + '/filter_test2_rewrite.png')
      File.delete('./filter_test2_rewrite.png')
    end

    png1.write path: './filter_test1_rewrite'
    png2.write path: './filter_test2_rewrite'
    
    expect(File.exist?(Dir.pwd + '/filter_test1_rewrite.png')).to eq(true)
    expect(File.exist?(Dir.pwd + '/filter_test2_rewrite.png')).to eq(true)
  end

  it "can combine images together" do 

        
    desktop_path = "/mnt/c/users/micah/Desktop/"

    rest2 = Rbimg::PNG.read(path: desktop_path + 'rest2')
    rest12 = Rbimg::PNG.read(path: desktop_path + 'rest12')
    rest22 = Rbimg::PNG.read(path: desktop_path + 'rest22')
    rest32 = Rbimg::PNG.read(path: desktop_path + 'rest32')
    rest42 = Rbimg::PNG.read(path: desktop_path + 'rest42')

    rest272 = Rbimg::PNG.read(path: desktop_path + 'rest272')

    divider = Array.new(400,255)

    imgs = [rest2, rest12, rest22, rest32, rest42, rest272]

    new_width = imgs.length * 28 + (divider.length * (imgs.length - 1))
    new_height = 28


    new_pixels = 28.times.map do |row|
        row_start = row * 28

        imgs.map do |img|
            row_pixels = imgs.pixels[row_start...(row_start + 28)] 
            img == imgs.last ? row_pixels : row_pixels + divider
        end
    end.flatten

    new_img = Rbimg::PNG.new(pixels: new_pixels, type: :greyscale, width: new_width, height: new_height)
    new_img.write(path: desktop_path + "img_row")
    expect(false).to eq(true)
  end

  it "can create a png image from the MNIST image data" do
    img_data = File.read("./data/t10k-images-idx3-ubyte").bytes
    mag_num = img_data[0...4]
    num_imgs = img_data[4...8]
    num_rows = img_data[8...12]
    num_cols = img_data[12...16]
    pixels = img_data[16...(16 + 784)]
    png = Rbimg::PNG.new(pixels: pixels, type: :greyscale, width: 28, height: 28)
    if File.exist?(Dir.pwd + '/mnist.png')
      File.delete(Dir.pwd + '/mnist.png')
    end
    png.write(path: "./mnist")
    expect(File.exist?(Dir.pwd + '/mnist.png')).to eq(true)
  end

  it "creates a valid rgb PNG img" do
    pixels = []
    1000.times do |i|
      if i % 2 == 0
        pixels << ([0, 255, 255] * 1000)
      else
        pixels << ([255, 0, 0] * 1000)
      end
    end
    png = Rbimg::PNG.new(pixels: pixels.flatten, type: :rgb, width: 1000, height: 1000)
    if File.exist?(Dir.pwd + '/rgb_striped.png')
      File.delete(Dir.pwd + '/rgb_striped.png')
    end
    png.write(path: "./rgb_striped")
    expect(File.exist?(Dir.pwd + '/rgb_striped.png')).to eq(true)
  end

  it 'can create a valid greyscale PNG img' do 
    pixels = []
    1000.times do |i|
      if i % 2 == 0
        pixels << ([0] * 1000)
      else
        pixels << ([111] * 1000)
      end
    end
    png = Rbimg::PNG.new(pixels: pixels.flatten, type: :greyscale, width: 1000, height: 1000)
    if File.exist?(Dir.pwd + '/greyscale_striped.png')
      File.delete(Dir.pwd + '/greyscale_striped.png')
    end
    png.write(path: "./greyscale_striped")
    expect(File.exist?(Dir.pwd + '/greyscale_striped.png')).to eq(true)
  end

  it 'can create a valid rgba PNG img' do 
    pixels = []
    1000.times do |i|
      if i % 2 == 0
        pixels << ([0, 0, 255, 200] * 1000)
      else
        pixels << ([0, 255, 0, 200] * 1000)
      end
    end
    png = Rbimg::PNG.new(pixels: pixels.flatten, type: :rgba, width: 1000, height: 1000)
    if File.exist?(Dir.pwd + '/rgba_striped.png')
      File.delete(Dir.pwd + '/rgba_striped.png')
    end
    png.write(path: "./rgba_striped")
    expect(File.exist?(Dir.pwd + '/rgba_striped.png')).to eq(true)
  end

  it "can read and rewrite a valid rgba img" do 
    png = Rbimg::PNG.read(path: './rgba_striped.png')
    png.write(path: './rgba_rewrite')
  end

  it 'can create a valid greyscale alpha PNG img' do 
    pixels = []
    1000.times do |i|
      if i % 2 == 0
        pixels << ([0, 200] * 1000)
      else
        pixels << ([111, 200] * 1000)
      end
    end
    png = Rbimg::PNG.new(pixels: pixels.flatten, type: :greyscale_alpha, width: 1000, height: 1000)
    if File.exist?(Dir.pwd + '/greyscale_alpha_striped.png')
      File.delete(Dir.pwd + '/greyscale_alpha_striped.png')
    end
    png.write(path: "./greyscale_alpha_striped")
    expect(File.exist?(Dir.pwd + '/greyscale_alpha_striped.png')).to eq(true)
  end

  it 'can correctly read an rbg png file' do
    out = Rbimg::PNG.read(path: './data/smiley.png')
    expect{out.write}.to_not raise_error
    out2 = Rbimg::PNG.read(path: './output.png')
    expect{out2.write}.to_not raise_error
  end

  it 'correctly generates the PNG signature' do 
    png = Rbimg::PNG.new(width: 1, height: 1, type: :greyscale, pixels: [0])
    expect(png.bytes[0...8]).to eq([137, 80, 78, 71, 13, 10, 26, 10].pack("C8"))
  end

  describe "::Chunk" do

    describe ".IHDR" do 

      it 'correclty generates the IHDR chunk' do 
        ihdr = Rbimg::PNG::Chunk.IHDR(width: 1673, height: 968, bit_depth: 8, color_type: 2)
        ihdr_bytes_expected = "\u0000\u0000\u0000\rIHDR\u0000\u0000\u0006\x89\u0000\u0000\u0003\xC8\b\u0002\u0000\u0000\u0000\x8A\u001F\x85\x89".bytes.pack("C*")

        ihdr2 = Rbimg::PNG::Chunk.IHDR(width: 1902, height: 1728, bit_depth: 8, color_type: 6)
        ihdr2_bytes_expected = "\x00\x00\x00\rIHDR\x00\x00\an\x00\x00\x06\xC0\b\x06\x00\x00\x00\xAF\xA6v\xDC".bytes.pack("C*")

        expect(ihdr.bytes).to eq(ihdr_bytes_expected)
        expect(ihdr2.bytes).to eq(ihdr2_bytes_expected)
      end

      it "throws an error if height or width are 0" do 
        expect{Rbimg::PNG::Chunk.IHDR(width: 1902, height: 0, bit_depth: 8, color_type: 2)}.to raise_error(ArgumentError, 'Width or height cannot be 0')
        expect{Rbimg::PNG::Chunk.IHDR(width: 0, height: 968, bit_depth: 8, color_type: 2)}.to raise_error(an_instance_of(ArgumentError).and having_attributes({"message" => "Width or height cannot be 0"}))
      end

      it "throws an error if color code is not 0,2,3,4, or 6" do  
        expect{Rbimg::PNG::Chunk.IHDR(width: 1902, height: 986, bit_depth: 8, color_type: 1)}.to raise_error(an_instance_of(ArgumentError).and having_attributes({"message" => 'Color code types must be 0, 2, 3, 4, or 6'}))
        for el in [0,2,3,4,6] 
          expect{Rbimg::PNG::Chunk.IHDR(width:1902, height: 986, bit_depth: 8, color_type: el)}.not_to raise_error
        end
      end

      it "follows the bit depth rules" do 
        expect(false).to eq(true)
      end

    end

    it 'correclty implements the CRC algorithm' do 
      data = [
        73, 67, 67, 32, 80, 114, 111, 102, 105, 108, 101, 0, 0, 72, 137, 149, 151, 7, 84, 83, 217, 22, 134, 207, 189, 233, 141, 150, 128, 116, 66, 
        111, 130, 20, 233, 2, 9, 61, 20, 233, 213, 70, 72, 2, 9, 37, 132, 132, 160, 98, 71, 6, 21, 28, 11, 42, 34, 96, 67, 71, 69, 20, 28, 149, 34, 
        99, 69, 20, 219, 160, 96, 67, 69, 39, 200, 32, 160, 140, 131, 5, 27, 106, 222, 5, 30, 97, 230, 189, 245, 222, 91, 239, 95, 235, 172, 251, 173, 
        125, 247, 217, 123, 159, 115, 239, 89, 107, 31, 0, 40, 104, 182, 72, 148, 9, 171, 0, 144, 37, 204, 21, 71, 5, 250, 208, 19, 18, 147, 232, 184, 
        62, 64, 2, 106, 0, 2, 42, 64, 131, 205, 145, 136, 152, 17, 17, 161, 0, 209, 212, 243, 239, 250, 240, 0, 241, 68, 116, 215, 102, 60, 214, 191, 
        191, 255, 175, 82, 229, 242, 36, 28, 0, 160, 8, 132, 83, 184, 18, 78, 22, 194, 167, 145, 241, 146, 35, 18, 231, 2, 128, 218, 135, 216, 141, 23, 
        231, 138, 198, 185, 13, 97, 154, 24, 41, 16, 225, 238, 113, 78, 155, 228, 225, 113, 78, 153, 96, 52, 152, 240, 137, 137, 242, 69, 152, 6, 0, 158, 
        204, 102, 139, 211, 0, 32, 211, 17, 59, 61, 143, 147, 134, 196, 33, 51, 16, 182, 19, 114, 5, 66, 132, 69, 8, 123, 113, 248, 108, 46, 194, 39, 
        16, 158, 153, 149, 149, 61, 206, 61, 8, 91, 164, 252, 37, 78, 218, 223, 98, 166, 40, 98, 178, 217, 105, 10, 158, 92, 203, 132, 240, 126, 2, 137, 
        40, 147, 189, 244, 255, 220, 142, 255, 173, 172, 76, 233, 84, 14, 51, 100, 144, 249, 226, 160, 168, 241, 124, 200, 158, 117, 103, 100, 135, 40, 
        88, 152, 50, 55, 124, 138, 5, 220, 201, 154, 198, 153, 47, 13, 138, 157, 98, 142, 196, 55, 105, 138, 185, 108, 191, 16, 197, 220, 204, 185, 161, 
        83, 156, 42, 8, 96, 41, 226, 228, 178, 98, 166, 152, 39, 241, 143, 158, 98, 113, 118, 148, 34, 87, 170, 216, 151, 57, 197, 108, 241, 68, 94, 34, 
        194, 50, 105, 70, 172, 194, 206, 231, 177, 20, 241, 243, 249, 49, 241, 83, 156, 39, 136, 155, 59, 197, 146, 140, 232, 144, 105, 31, 95, 133, 93, 
        44, 141, 82, 212, 207, 19, 6, 250, 76, 231, 13, 80, 172, 61, 75, 242, 151, 245, 10, 88, 138, 185, 185, 252, 152, 32, 197, 218, 217, 211, 245, 
        243, 132, 204, 233, 152, 146, 4, 69, 109, 92, 158, 159, 255, 180, 79, 172, 194, 95, 148, 235, 163, 200, 37, 202, 140, 80, 248, 243, 50, 3, 21, 
        118, 73, 94, 180, 98, 110, 46, 242, 67, 78, 207, 141, 80, 236, 97, 58, 59, 56, 98, 138, 129, 0, 132, 1, 54, 224, 208, 149, 167, 8, 128, 92, 
        222, 146, 220, 241, 133, 248, 102, 139, 150, 138, 5, 105, 252, 92, 58, 19, 57, 97, 60, 58, 75, 200, 177, 157, 73, 119, 176, 179, 119, 3, 96, 
        252, 188, 78, 254, 14, 35, 183, 39, 206, 33, 164, 165, 58, 109, 91, 183, 3, 0, 239, 149, 114, 185, 188, 97, 218, 22, 216, 12, 192, 137, 72, 
        228, 179, 28, 159, 182, 153, 175, 7, 64, 197, 30, 128, 107, 55, 57, 82, 113, 222, 164, 109, 226, 44, 97, 144, 175, 167, 12, 104, 64, 11, 232, 
        3, 99, 96, 1, 108, 128, 3, 112, 6, 30, 128, 1, 252, 65, 48, 8, 7, 49, 32, 17, 44, 68, 106, 229, 131, 44, 32, 6, 139, 193, 114, 176, 6, 20, 129, 
        18, 176, 5, 236, 0, 21, 96, 47, 56, 0, 142, 128, 227, 224, 36, 104, 2, 103, 193, 37, 112, 21, 220, 4, 119, 192, 125, 240, 4, 200, 64, 63, 120, 
        5, 70, 192, 7, 48, 6, 65, 16, 14, 162, 64, 84, 72, 11, 50, 128, 76, 33, 107, 200, 1, 114, 133, 188, 32, 127, 40, 20, 138, 130, 18, 161, 100, 
        40, 13, 18, 66, 82, 104, 57, 180, 22, 42, 129, 74, 161, 10, 104, 63, 84, 3, 253, 12, 157, 129, 46, 65, 215, 161, 78, 232, 17, 212, 11, 13, 65, 
        111, 161, 47, 48, 10, 38, 195, 52, 88, 15, 54, 131, 103, 193, 174, 48, 19, 14, 129, 99, 224, 5, 112, 26, 156, 3, 231, 195, 133, 240, 38, 184, 
        28, 174, 134, 143, 193, 141, 240, 37, 248, 38, 124, 31, 150, 193, 175, 224, 81, 20, 64, 145, 80, 26, 40, 67, 148, 13, 202, 21, 229, 139, 10, 
        71, 37, 161, 82, 81, 98, 212, 74, 84, 49, 170, 12, 85, 141, 170, 67, 181, 160, 218, 81, 119, 81, 50, 212, 48, 234, 51, 26, 139, 166, 162, 233, 
        104, 27, 180, 7, 58, 8, 29, 139, 230, 160, 115, 208, 43, 209, 27, 209, 21, 232, 35, 232, 70, 116, 27, 250, 46, 186, 23, 61, 130, 254, 142, 
        161, 96, 116, 49, 214, 24, 119, 12, 11, 147, 128, 73, 195, 44, 198, 20, 97, 202, 48, 135, 48, 13, 152, 43, 152, 251, 152, 126, 204, 7, 44, 
        22, 171, 129, 53, 199, 186, 96, 131, 176, 137, 216, 116, 236, 50, 236, 70, 236, 110, 108, 61, 246, 34, 182, 19, 219, 135, 29, 197, 225, 
        112, 90, 56, 107, 156, 39, 46, 28, 199, 198, 229, 226, 138, 112, 187, 112, 199, 112, 23, 112, 93, 184, 126, 220, 39, 60, 9, 111, 128, 119, 
        192, 7, 224, 147, 240, 66, 124, 1, 190, 12, 127, 20, 127, 30, 223, 133, 31, 192, 143, 17, 84, 8, 166, 4, 119, 66, 56, 129, 75, 88, 74, 216, 
        76, 56, 72, 104, 33, 220, 38, 244, 19, 198, 136, 170, 68, 115, 162, 39, 49, 134, 152, 78, 92, 67, 44, 39, 214, 17, 175, 16, 123, 136, 239, 
        72, 36, 146, 17, 201, 141, 20, 73, 18, 144, 86, 147, 202, 73, 39, 72, 215, 72, 189, 164, 207, 100, 53, 178, 21, 217, 151, 60, 159, 44, 37, 
        111, 34, 31, 38, 95, 36, 63, 34, 191, 163, 80, 40, 102, 20, 6, 37, 137, 146, 75, 217, 68, 169, 161, 92, 166, 60, 163, 124, 82, 162, 42, 
        217, 42, 177, 148, 184, 74, 171, 148, 42, 149, 26, 149, 186, 148, 94, 43, 19, 148, 77, 149, 153, 202, 11, 149, 243, 149, 203, 148, 79, 41, 
        223, 86, 30, 86, 33, 168, 152, 169, 248, 170, 176, 85, 86, 170, 84, 170, 156, 81, 121, 168, 50, 170, 74, 85, 181, 87, 13, 87, 205, 82, 221,
        168, 122, 84, 245, 186, 234, 160, 26, 78, 205, 76, 205, 95, 141, 171, 86, 168, 118, 64, 237, 178, 90, 31, 21, 69, 53, 166, 250, 82, 57, 
        212, 181, 212, 131, 212, 43, 212, 126, 26, 150, 102, 78, 99, 209, 210, 105, 37, 180, 227, 180, 14, 218, 136, 186, 154, 250, 108, 245, 56, 
        245, 37, 234, 149, 234, 231, 212, 101, 26, 40, 13, 51, 13, 150, 70, 166, 198, 102, 141, 147, 26, 15, 52, 190, 204, 208, 155, 193, 156, 
        193, 155, 177, 97, 70, 221, 140, 174, 25, 31, 53, 117, 52, 25, 154, 60, 205, 98, 205, 122, 205, 251, 154, 95, 180, 232, 90, 254, 90, 25, 
        90, 91, 181, 154, 180, 158, 106, 163, 181, 173, 180, 35, 181, 23, 107, 239, 209, 190, 162, 61, 172, 67, 211, 241, 208, 225, 232, 20, 235, 
        156, 212, 121, 172, 11, 235, 90, 233, 70, 233, 46, 211, 61, 160, 123, 75, 119, 84, 79, 95, 47, 80, 79, 164, 183, 75, 239, 178, 222, 176, 
        190, 134, 62, 67, 63, 93, 127, 187, 254, 121, 253, 33, 3, 170, 129, 151, 129, 192, 96, 187, 193, 5, 131, 151, 116, 117, 58, 147, 158, 73, 
        47, 167, 183, 209, 71, 12, 117, 13, 131, 12, 165, 134, 251, 13, 59, 12, 199, 140, 204, 141, 98, 141, 10, 140, 234, 141, 158, 26, 19, 141, 
        93, 141, 83, 141, 183, 27, 183, 26, 143, 152, 24, 152, 132, 153, 44, 55, 169, 53, 121, 108, 74, 48, 117, 53, 229, 155, 238, 52, 109, 55, 
        253, 104, 102, 110, 22, 111, 182, 206, 172, 201, 108, 208, 92, 211, 156, 101, 158, 111, 94, 107, 222, 99, 65, 177, 240, 182, 200, 177, 
        168, 182, 184, 103, 137, 181, 116, 181, 204, 176, 220, 109, 121, 199, 10, 182, 114, 178, 226, 91, 85, 90, 221, 182, 134, 173, 157, 173, 
        5, 214, 187, 173, 59, 103, 98, 102, 186, 205, 20, 206, 172, 158, 249, 208, 134, 108, 195, 180, 201, 179, 169, 181, 233, 181, 213, 176, 
        13, 181, 45, 176, 109, 178, 125, 61, 203, 100, 86, 210, 172, 173, 179, 218, 103, 125, 183, 115, 178, 203, 180, 59, 104, 247, 196, 94, 
        205, 62, 216, 190, 192, 190, 197, 254, 173, 131, 149, 3, 199, 161, 210, 225, 158, 35, 197, 49, 192, 113, 149, 99, 179, 227, 155, 217, 
        214, 179, 121, 179, 247, 204, 238, 118, 162, 58, 133, 57, 173, 115, 106, 117, 250, 230, 236, 226, 44, 118, 174, 115, 30, 114, 49, 113, 
        73, 118, 169, 114, 121, 232, 74, 115, 141, 112, 221, 232, 122, 205, 13, 227, 230, 227, 182, 202, 237, 172, 219, 103, 119, 103, 247, 92, 
        247, 147, 238, 127, 122, 216, 120, 100, 120, 28, 245, 24, 156, 99, 62, 135, 55, 231, 224, 156, 62, 79, 35, 79, 182, 231, 126, 79, 153, 
        23, 221, 43, 217, 107, 159, 151, 204, 219, 208, 155, 237, 93, 237, 253, 156, 97, 204, 224, 50, 14, 49, 6, 152, 150, 204, 116, 230, 49, 
        230, 107, 31, 59, 31, 177, 79, 131, 207, 71, 95, 119, 223, 21, 190, 23, 253, 80, 126, 129, 126, 197, 126, 29, 254, 106, 254, 177, 254, 
        21, 254, 207, 2, 140, 2, 210, 2, 106, 3, 70, 2, 157, 2, 151, 5, 94, 12, 194, 4, 133, 4, 109, 13, 122, 200, 210, 99, 113, 88, 53, 172, 
        145, 96, 151, 224, 21, 193, 109, 33, 228, 144, 232, 144, 138, 144, 231, 161, 86, 161, 226, 208, 150, 48, 56, 44, 56, 108, 91, 88, 207, 
        92, 211, 185, 194, 185, 77, 225, 32, 156, 21, 190, 45, 252, 105, 132, 121, 68, 78, 196, 47, 145, 216, 200, 136, 200, 202, 200, 23, 81, 
        246, 81, 203, 163, 218, 163, 169, 209, 139, 162, 143, 70, 127, 136, 241, 137, 217, 28, 243, 36, 214, 34, 86, 26, 219, 26, 167, 28, 55, 63, 
        174, 38, 238, 99, 188, 95, 124, 105, 188, 44, 97, 86, 194, 138, 132, 155, 137, 218, 137, 130, 196, 230, 36, 92, 82, 92, 210, 161, 164, 209, 
        121, 254, 243, 118, 204, 235, 159, 239, 52, 191, 104, 254, 131, 5, 230, 11, 150, 44, 184, 190, 80, 123, 97, 230, 194, 115, 139, 148, 23, 177, 
        23, 157, 74, 198, 36, 199, 39, 31, 77, 254, 202, 14, 103, 87, 179, 71, 83, 88, 41, 85, 41, 35, 28, 95, 206, 78, 206, 43, 46, 131, 187, 157, 59, 
        196, 243, 228, 149, 242, 6, 82, 61, 83, 75, 83, 7, 211, 60, 211, 182, 165, 13, 241, 189, 249, 101, 252, 97, 129, 175, 160, 66, 240, 38, 61, 40, 
        125, 111, 250, 199, 140, 240, 140, 195, 25, 242, 204, 248, 204, 250, 44, 124, 86, 114, 214, 25, 161, 154, 48, 67, 216, 150, 173, 159, 189, 36, 
        187, 83, 100, 45, 42, 18, 201, 114, 220, 115, 118, 228, 140, 136, 67, 196, 135, 36, 144, 100, 129, 164, 57, 151, 134, 52, 70, 183, 164, 22, 
        210, 31, 164, 189, 121, 94, 121, 149, 121, 159, 22, 199, 45, 62, 181, 68, 117, 137, 112, 201, 173, 165, 86, 75, 55, 44, 29, 200, 15, 200, 
        255, 105, 25, 122, 25, 103, 89, 235, 114, 195, 229, 107, 150, 247, 174, 96, 174, 216, 191, 18, 90, 153, 178, 178, 117, 149, 241, 170, 194, 
        85, 253, 171, 3, 87, 31, 89, 67, 92, 147, 177, 230, 215, 2, 187, 130, 210, 130, 247, 107, 227, 215, 182, 20, 234, 21, 174, 46, 236, 251, 33, 
        240, 135, 218, 34, 165, 34, 113, 209, 195, 117, 30, 235, 246, 174, 71, 175, 23, 172, 239, 216, 224, 184, 97, 215, 134, 239, 197, 220, 226, 
        27, 37, 118, 37, 101, 37, 95, 55, 114, 54, 222, 248, 209, 254, 199, 242, 31, 229, 155, 82, 55, 117, 108, 118, 222, 188, 103, 11, 118, 139, 
        112, 203, 131, 173, 222, 91, 143, 148, 170, 150, 230, 151, 246, 109, 11, 219, 214, 184, 157, 190, 189, 120, 251, 251, 29, 139, 118, 92, 47, 
        155, 93, 182, 119, 39, 113, 167, 116, 167, 172, 60, 180, 188, 121, 151, 201, 174, 45, 187, 190, 86, 240, 43, 238, 87, 250, 84, 214, 87, 233, 
        86, 109, 168, 250, 184, 155, 187, 187, 107, 15, 99, 79, 221, 94, 189, 189, 37, 123, 191, 236, 19, 236, 235, 222, 31, 184, 191, 177, 218, 
        172, 186, 236, 0, 246, 64, 222, 129, 23, 7, 227, 14, 182, 255, 228, 250, 83, 205, 33, 237, 67, 37, 135, 190, 29, 22, 30, 150, 29, 137, 58, 
        210, 86, 227, 82, 83, 115, 84, 247, 232, 230, 90, 184, 86, 90, 59, 116, 108, 254, 177, 59, 199, 253, 142, 55, 215, 217, 212, 237, 175, 215, 
        168, 47, 57, 1, 78, 72, 79, 188, 252, 57, 249, 231, 7, 39, 67, 78, 182, 158, 114, 61, 85, 119, 218, 244, 116, 85, 3, 181, 161, 184, 17, 106, 
        92, 218, 56, 210, 196, 111, 146, 53, 39, 54, 119, 158, 9, 62, 211, 218, 226, 209, 210, 240, 139, 237, 47, 135, 207, 26, 158, 173, 60, 167, 126, 
        110, 243, 121, 226, 249, 194, 243, 242, 11, 249, 23, 70, 47, 138, 46, 14, 95, 74, 187, 212, 215, 186, 168, 245, 201, 229, 132, 203, 247, 218, 
        34, 219, 58, 174, 132, 92, 185, 118, 53, 224, 234, 229, 118, 102, 251, 133, 107, 158, 215, 206, 94, 119, 191, 126, 230, 134, 235, 141, 166, 155, 
        206, 55, 27, 111, 57, 221, 106, 248, 213, 233, 215, 134, 14, 231, 142, 198, 219, 46, 183, 155, 239, 184, 221, 105, 233, 156, 211, 121, 190, 203, 
        187, 235, 210, 93, 191, 187, 87, 239, 177, 238, 221, 188, 63, 247, 126, 231, 131, 216, 7, 221, 15, 231, 63, 148, 117, 115, 187, 7, 31, 101, 62, 
        122, 243, 56, 239, 241, 216, 147, 213, 61, 152, 158, 226, 167, 42, 79, 203, 158, 233, 62, 171, 254, 205, 242, 183, 122, 153, 179, 236, 92, 175, 
        95, 239, 173, 231, 209, 207, 159, 244, 113, 250, 94, 253, 46, 249, 253, 107, 127, 225, 11, 202, 139, 178, 1, 131, 129, 154, 65, 135, 193, 179, 
        67, 1, 67, 119, 94, 206, 123, 217, 255, 74, 244, 106, 108, 184, 232, 15, 213, 63, 170, 94, 91, 188, 62, 253, 39, 227, 207, 91, 35, 9, 35, 253, 
        111, 196, 111, 228, 111, 55, 190, 211, 122, 119, 248, 253, 236, 247, 173, 163, 17, 163, 207, 62, 100, 125, 24, 251, 88, 252, 73, 235, 211, 145, 
        207, 174, 159, 219, 191, 196, 127, 25, 24, 91, 252, 21, 247, 181, 252, 155, 229, 183, 150, 239, 33, 223, 123, 228, 89, 114, 185, 136, 45, 102, 
        79, 180, 2, 40, 100, 192, 169, 169, 0, 188, 61, 12, 0, 37, 17, 0, 234, 29, 164, 127, 152, 55, 217, 79, 79, 8, 154, 188, 3, 76, 16, 248, 79, 60, 
        217, 115, 79, 200, 25, 128, 58, 228, 49, 222, 22, 49, 46, 2, 112, 106, 245, 100, 59, 171, 132, 112, 56, 3, 128, 24, 6, 128, 29, 29, 21, 227, 
        159, 146, 164, 58, 58, 76, 198, 82, 170, 5, 0, 103, 40, 151, 191, 205, 6, 128, 128, 140, 175, 129, 114, 249, 88, 132, 92, 254, 173, 10, 41, 
        246, 30, 0, 231, 7, 39, 251, 248, 113, 97, 145, 219, 77, 157, 142, 85, 255, 165, 248, 187, 93, 173, 224, 95, 245, 15, 69, 154, 18, 28, 79, 
        190, 181, 136, 0, 0, 0, 138, 101, 88, 73, 102, 77, 77, 0, 42, 0, 0, 0, 8, 0, 4, 1, 26, 0, 5, 0, 0, 0, 1, 0, 0, 0, 62, 1, 27, 0, 5, 0, 0, 0, 
        1, 0, 0, 0, 70, 1, 40, 0, 3, 0, 0, 0, 1, 0, 2, 0, 0, 135, 105, 0, 4, 0, 0, 0, 1, 0, 0, 0, 78, 0, 0, 0, 0, 0, 0, 0, 144, 0, 0, 0, 1, 0, 0, 0, 
        144, 0, 0, 0, 1, 0, 3, 146, 134, 0, 7, 0, 0, 0, 18, 0, 0, 0, 120, 160, 2, 0, 4, 0, 0, 0, 1, 0
      ]
      chunk_data = data.take(2752)
      code = "iCCP"
      expected_crc = data[2752...2756].pack("C*") #[79,190,181,136].pack("C*")
      chunk = Rbimg::PNG::Chunk.new(type: code, data: chunk_data)
      actual_crc = chunk.bytes[-4..-1]
      expect(expected_crc).to eq(actual_crc)
    end

    it 'supports all the allowed filtering methods' do 
      expect(false).to eq(true)
    end

  
    describe ".readIHDR" do
    
      it "correctly reads the IHDR chunk as a buffer or bytestring and returns a hash of metadata" do 
        ihdr = [0, 0, 0, 13, 73, 72, 68, 82, 0, 0, 7, 110, 0, 0, 6, 192, 8, 6, 0, 0, 0, 175, 166, 118, 220]
        ihdrbytes = Byteman.buf2hex(ihdr)
        buf_data = Rbimg::PNG::Chunk.readIHDR(ihdr)
        bytes_data = Rbimg::PNG::Chunk.readIHDR(ihdrbytes)

        expect(buf_data).to eq(bytes_data)

        data = buf_data
        #width: 1902, height: 1728, bit_depth: 8, color_type: 6
        expected_data = {
          length: 13,
          width: 1902, 
          height: 1728,
          bit_depth: 8,
          color_type: 6,
          compression_method: 0,
          filter_method: 0,
          interlace_method: 0,
          chunk_data: [0,0,7,110,0,0,6,192,8,6,0,0,0],
          crc: [175,166,118,220],
          type: "IHDR"
        }
        
        expect(data).to eq(expected_data)

      end

      it "verifies the CRC" do 
        ihdr = [0, 0, 0, 13, 73, 72, 68, 82, 0, 0, 7, 110, 0, 0, 6, 192, 8, 6, 0, 0, 0, 175, 166, 118, 221]
        expect{Rbimg::PNG::Chunk.readIHDR(ihdr)}.to raise_error(Rbimg::CRCError)
      end

  end

  describe ".PLTE" do 
    
    it "throws an error if the data length is not a multiple of 3" do 
      expect{Rbimg::PNG::Chunk.PLTE([1,2,4,2])}.to raise_error(ArgumentError, "Number of bytes must be a multiple of 3")
      expect{Rbimg::PNG::Chunk.PLTE([255] * (3 * 123))}.not_to raise_error
    end

  end

  describe ".IDAT" do 

    it "corectly writes the IDAT chunk" do 
      expect(false).to eq(true)
    end

    

  end



end





  describe ".read" do 

    it "accepts a path or a datastream" do 

      expect{Rbimg::PNG.read}.to raise_error(ArgumentError, ".read must be initialized with a path or a datastream")
      expect{Rbimg::PNG.read(path: "./data/smiley.png", data: "mydata")}.to raise_error(ArgumentError, ".read must be initialized with a path or a datastream")
      expect{Rbimg::PNG.read(path: "./data/smiley.png")}.not_to raise_error
      expect{Rbimg::PNG.read(data: File.read('./data/smiley.png'))}.not_to raise_error

    end

    it "allows datastream to be bytes or an array of byte integers" do 
      expect{Rbimg::PNG.read(data: File.read('./data/smiley.png').bytes)}.not_to raise_error
      expect{Rbimg::PNG.read(data: File.read('./data/smiley.png'))}.not_to raise_error
      expect{Rbimg::PNG.read(data: 122345)}.to raise_error(ArgumentError)
    end

    it "throws a Rbimg::FormatError when an invalid file or data is provided" do
      expect{Rbimg::PNG.read(data: [12, 52, 144, 93])}.to raise_error(Rbimg::FormatError)
      expect{Rbimg::PNG.read(data: "this is not a valid image")}.to raise_error(Rbimg::FormatError)
    end

    it "correctly gathers metadata from the IHDR Chunk" do 
      png = Rbimg::PNG.read(path: "./data/smiley.png")
      expected_data = {
        width: 194,
        height: 238,
        bit_depth: 8,
        color_type: :rgb,
        compression_method: 0,
        filter_method: 0,
        interlace_method: 0
      }
      expect(png.width).to eq(expected_data[:width])
      expect(png.height).to eq(expected_data[:height])
      expect(png.bit_depth).to eq(expected_data[:bit_depth])
      expect(png.type).to eq(expected_data[:color_type])
      expect(png.compression_method).to eq(expected_data[:compression_method])
      expect(png.filter_method).to eq(expected_data[:filter_method])
      expect(png.interlace_method).to eq(expected_data[:interlace_method])
    end

  end

  


  describe ".readChunk" do 

    it "correctly reads the length, type, and crc" do 


      expect(false).to eq(true)

    end

  end

end

