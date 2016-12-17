extern crate docopt;
use docopt::Docopt;


pub struct Cli {
  m: Option<docopt::ArgvMap>,
}


impl Cli {
    fn new() -> Cli {
      return Cli{m: None}; 
    }
    pub fn get_arg(self, arg: &str) -> String {
        let t = self.m.unwrap();

        let v = t.get_str(arg);
        return String::from(v);
    }
}

pub fn init_cli<'_>(cli: &str) -> Cli {
    let mut c = Cli::new();
    let args = Docopt::new(cli)
                                .and_then(|d| d.parse())
                                .unwrap_or_else(|e| e.exit());
    c.m = Some(args);
    return c;
}


