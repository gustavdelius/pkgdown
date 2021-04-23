# build_redirect() works

    Code
      cat(read_lines(file.path(pkg$dst_path, "old.html")))
    Output
           <html>       <head>         <meta http-equiv="refresh" content="0;URL=https://example.com/new.html" />         <script language="javascript">         window.location.href = "https://example.com/new.html"         </script>       </head>     </html>   

# build_redirect() errors when wrong paths

    Can't find the page bla from redirects.

---

    Must redirect an non-existing page:
    Page(s) nada from redirects exist(s) in the built site.

