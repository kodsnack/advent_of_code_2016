extern crate docopt;
use docopt::Docopt;


pub struct Cli {
  m: docopt::ArgvMap,
}


impl Cli {
    fn new(map: docopt::ArgvMap) -> Cli {
      return Cli{m: map}; 
    }
    pub fn get_arg(self, arg: &str) -> String {

        let v = self.m.get_str(arg);
        return String::from(v);
    }
}

pub fn init_cli<'_>(cli: &str) -> Cli {
    let args = Docopt::new(cli)
                                .and_then(|d| d.parse())
                                .unwrap_or_else(|e| e.exit());
    let mut c = Cli::new(args);
    return c;
}


