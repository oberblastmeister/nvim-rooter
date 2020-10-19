(module nvim-rooter.main
  require {a aniseed.core
            nvim_lsp nvim_lsp
            vim vim})

(def- rooter {:cmd (.. "autocmd VimEnter,BufReadPost,BufEnter * ++nested " 
                     "lua require'rooter'.root_async()")})

(def- current-working-directory nil)

(def- start-path-fn nil)

(def- root-fn nil)

(def- config {:manual false
              :echo true
              :patterns {:.git :Cargo.toml :go.mod}
              :cd-command "lcd"
              :non-project-files "current"
              :filetypes-exclude nil
              :start-path (fn []
                           (vim.fn.expand "%:p:h"))})

(defn- get-new-directory []
  (let [res (root-fn) (start-path-fn)]
    (if res
      res
      (let [non-project-files (. config non-project-files)]
        (if
          (= non-project-files "current")
          (start-path-fn)
          (= non-project-files "home")
          ("~"))))))

(def root
  (if (not= (. (. vim bo) filetype) (a.get config :filetypes-exclude))
    (if (not= (. (. vim bo) buftype "terminal"))
      (let [new-dir (get-new-directory)]
        (if (not= new-dir (a.get current-working-directory))
          (if (a.get config :echo)
            (print (.. "[rooter changing directory to " new-dir))
            (vim.cmd (.. (a.get config cd-command) " " new-dir))
            (a.set current-working-directory new-dir)))))))
         
    
          
(def- current-working-directory nil)

(defn init []
  (print "Hello, World!"))

(defn- get-new-directory []
 ())
