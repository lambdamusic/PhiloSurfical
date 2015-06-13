(load-all-patches)
(save-image "lw-console" :console t 
                         :restart-function 'mp:initialize-multiprocessing 
                         :environment nil)
(quit)
