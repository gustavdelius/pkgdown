# build_redirect() works

    Code
      cat(read_lines(file.path(pkg$dst_path, "old.html")))
    Output
      <html>   <head>     <meta http-equiv="refresh" content="0;URL=https://example.com/new.html#section" />     <meta name="robots" content="noindex">     <link rel="canonical" href="https://example.com/new.html#section">   </head> </html> 

# build_redirect() errors when wrong paths

    Must redirect an non-existing page:
    Page(s) nada.html from redirects exist(s) in the built site.

