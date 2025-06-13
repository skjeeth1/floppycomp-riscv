# file delete -force *.xpr *.os *.jou *.log *.srcs *.cache *.runs *.Xil
file delete -force -- {*}[glob *.xpr *.os *.jou *.log *.srcs *.cache *.runs .Xil *.hw *.ip_user_files *.sim *.str]