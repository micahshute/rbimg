# Rbimg

Allows simple creation and reading of images (currently only PNG images).

Supports all required chunk types (IHDR, PLTE, IDAT, IEND)

Filtering is not currently supported.

This gem is primarily for simple manipulation of images using pixel data.

You can easily write images from an array of pixel data, and retrieve pixel data from a PNG image.

Examples: 

Write simple 100x100 green-blue image

```ruby
pixels = []
100.times do
    pixels << Array.new(100, [0,255,255])
end
png = Rbimg::PNG.new(pixels: pixels.flatten, type: :rgb, width: 100, height: 100)
png.write(path: './green-blue')
```

Write simple 500x500 half blue half red rgba image

```ruby
pixels = []
500.times do |row|
    if row >= 250
        pixels << Array.new(500, [0,0,255,127])
    else
        pixels << Array.new(500, [255,0,0,127])
    end
end
png = Rbimg::PNG.new(pixels: pixels.flatten, type: :rgba, width: 500, height: 500)
png.write(path: './blue-red-alpha')
```

Write simple 300x500 half white half black greyscale image

```ruby
pixels = []
500.times do |row|
    if row >= 250
        pixels << Array.new(300, 255)
    else
        pixels << Array.new(300, 0)
    end
end
png = Rbimg::PNG.new(pixels: pixels.flatten, type: :greyscale, width: 300, height: 500)
png.write(path: './greyscale')
```

Write a greyscale-alpha version of the image above

```ruby
pixels = []
500.times do |row|
    if row >= 250
        pixels << Array.new(300, [255,175])
    else
        pixels << Array.new(300, [0,175])
    end
end
png = Rbimg::PNG.new(pixels: pixels.flatten, type: :greyscale_alpha, width: 300, height: 500)
png.write(path: './greyscale_alpha')
```
Write a greyscale image from the MSNT dataset:

```ruby
img_data = File.read("./data/t10k-images-idx3-ubyte").bytes
mag_num = img_data[0...4]
num_imgs = img_data[4...8]
num_rows = img_data[8...12]
num_cols = img_data[12...16]
pixels = img_data[16...(16 + 784)]
png = Rbimg::PNG.new(pixels: pixels, type: :greyscale, width: 28, height: 28)
png.write(path: 'mnst_test')
```

Read a PNG image and get the pixel array from a path

```ruby
png = Rbimg::PNG.read(path: './data/smiley.png')
puts png.pixels
```

Read a PNG image and get the pixel array from raw data

```ruby
data = File.read('./data/smiley.png')
png = Rbimg::PNG.read(data: data)
puts png.pixels
```



## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rbimg'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rbimg

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rbimg. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/rbimg/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rbimg project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/rbimg/blob/master/CODE_OF_CONDUCT.md).
