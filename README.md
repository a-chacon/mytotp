# Mytotp

Another TOTP cli app. Nice UI, simple to use and user-friendly.

![mytotp-gif](https://github.com/a-chacon/mytotp/blob/aa60f18d3ec9885440796a13f66d553f0d656e96/mytotp.gif)

## Main features

-   Add, remove and update services.
-   Configure period(code's duration) and number of digits(code's length).
-   Generate a TOTP.
-   Copy to clipboard the generated TOTP.
-   Generating codes in continuos mode.

## Installation

Install the gem by executing:

```bash
gem install mytotp
```

For the copy to clipboard functionality the [third party](https://www.rubydoc.info/gems/clipboard/1.3.6) gem say:

    Important note for Linux users: The clipboard requires the xsel or the xclip command-line program. On debian and ubuntu, xsel can be installed with: sudo apt-get install xsel

## Usage

For help on how to use:

```bash
mytotp -h
```

### Add a service

For add a new service use:

```bash
mytotp service add [Service] [Username] [Key] [Period] [Digits]
```

If you don't want to pass all arguments just leave blank and the interactive mode ask to you the necesary information.

### Remove a service

For remove a service use:

```bash
mytotp service remove [Service] [Username]
```

If you don't want to pass all arguments just leave blank and the interactive mode ask to you the necesary information.

### Generate a TOTP

For generate use:

```bash
mytotp generate [Service] [Username]
```

If you don't want to pass all arguments just leave blank and the interactive mode ask to you the necesary information.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Pending features

-   Password protect database (Important!).
-   Add a logger.
-   Tests needs work.
-   Update services.
-   Export and Import data.
-   Any good proposal?

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## License

The gem is available as open source under the terms of the [GPL-3.0 License](https://www.github.com/a-chacon/mytotp/blob/main/LICENSE).
