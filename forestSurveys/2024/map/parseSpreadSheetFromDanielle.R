f <- "SewardPark_Plot_Info_forPShannon.tsv"
tbl <- read.table(f, sep="\t", as.is=TRUE, nrow=-1, header=TRUE, fill=TRUE, quote="")
dim(tbl)  # 31 49
tbl <- subset(tbl, !is.na(latitude))
dim(tbl)  # 20 49
tbl[, c("date", "latitude", "longitude")]

tbl[, "latitude"]
tbl[, "longitude"]
