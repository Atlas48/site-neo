use std::env::args;
fn main() {
    let l:String = args().next().unwrap();
    match l.as_str() {
        "not_found.txti" => println!("404 - Page Not Found"),
        "index.txti" => println!("Atlas48's Archives"),
        _ => println!("Atlas48's Archives"),
    }
}