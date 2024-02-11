# Location Directives

The location is a block that tells what to do
when some endpoint is accessed, for instance /blog.

The try_files tells nginx to look for files or directories
with the uri name.

Inside the location we use the variable $uri, this
variable carries the full uri text, in this case is blog.
When we use the $uri with a slash to check if it is a directory
if a file with the name is not find.

The symbol ^ means to stop looking for other route if already
found one that satisfy

```conf
server {
    
    location ^ /blog/ {
        try_files $uri $uri.php $uri/ /fallback/fall.html;
    }

    location ^ /fallback {
        root /var/www/other;
    }
}
```