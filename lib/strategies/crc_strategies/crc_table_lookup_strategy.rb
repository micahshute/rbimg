class Rbimg::Strategies::CRCTableLookup

    @@crc_table = {}

    def self.make_crc_table
        for n in 0...256
            c = n
            for k in 0...8
                if c.odd? 
                    c = 3988292384 ^ (c >> 1)
                else
                    c = c >> 1
                end
            end
            @@crc_table[n] = c
        end
    end 

    def self.crc_table_computed
        @@crc_table.length > 0
    end



    def self.crc(type, data)
        c = ([255] * 4).pack("C4").unpack("L").first
        buff = type + data
        make_crc_table if !crc_table_computed
        for n in 0...buff.length
            c = @@crc_table[(c ^ buff[n]) & 255] ^ (c >> 8)
        end
        Byteman.int2buf(c ^ Byteman.buf2int([255] * 4))
    end

end