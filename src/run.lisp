(load "load1")
(load "load2")
(load "load3")

(format *error-output* "~S~%" (mp:initialize-multiprocessing))  
(format *error-output* "~S~%" (update-dispatcher))
(format *error-output* "~S~%" (hunchentoot:start-server :address "philosurfical-application.open.ac.uk" :port 8080))


