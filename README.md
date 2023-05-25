# odpicr

[ODPI-C](https://github.com/oracle/odpi) wrapper

Fork from [crystal-odpi](https://github.com/silkPK/crystal-odpi) library.

## Installation

### ODPI-C (Linux)

```bash
# Install Unix ODBC
sudo apt install unixodbc-dev

# Download latest release
https://github.com/oracle/odpi/releases

# Unzip file
tar -xvf v4.6.1.tar.gz

# Change to folder v4.6.1
cd v4.6.1

# Make and Install
sudo make
sudo make install
```

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     odpicr:
       github: xtokio/odpicr
   ```

2. Run `shards install`

## Usage

```crystal
require "odpicr"

DB.open "odpi://user:password@host:port/SID" do |db|
  db.exec "BEGIN EXECUTE IMMEDIATE 'drop table person'; EXCEPTION WHEN OTHERS THEN NULL; END;"
  db.exec "create table person (name varchar(30), age int)"
  db.exec "insert into person (name,age) values ('Paolino Paperino', 28)"

  puts "max age:"
  puts db.scalar "select max(age) from person"

  puts "person:"
  db.query "select name, age from person order by age desc" do |res|
    puts "#{res.column_name(0)} (#{res.column_name(1)})"
    res.each do
      puts "#{res.read} (#{res.read})"
    end
  end
end
```

## Contributing

1. Fork it (<https://github.com/xtokio/odpicr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [xtokio](https://github.com/xtokio) - creator and maintainer
