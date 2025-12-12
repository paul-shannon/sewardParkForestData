library(sf)
library(MASS)

f <- "https://pshannon.net/hemlockSurvey2024/tblFinal.csv"
tbl <- read.table(f, sep=",", header=TRUE, as.is=TRUE, nrow=-1, quote="")
dim(tbl)

seward.limits <- c(-122.25676, -122.248006, 47.548233, 47.562744) # from openstreetmap
cellCount <- 500
min.density <- 30000


tbl.h <- subset(tbl, h>=2) # | h <= 1)
f.healthy <- kde2d(tbl.h$lon, tbl.h$lat, n=cellCount, lims=seward.limits)
z <- f.healthy$z
range(z)
z[z <min.density] <- 0
f.healthy$z <- z
range(f.healthy$z)
image(f.healthy, main="healthy", col=healthy.colors) #, zlim = c(0, 0.05))
#dev.off()
contour(f.healthy, xlab = "healthy", add=TRUE)
contours.healthy <- contourLines(f.healthy)
length(contours.healthy)  # 9


tbl.s <- subset(tbl, h <= 1)
f.sick <- kde2d(tbl.s$lon, tbl.s$lat, n=cellCount, lims=seward.limits)
z <- f.sick$z
range(z)
z[z <min.density] <- 0
f.sick$z <- z
range(f.sick$z)
image(f.sick, main="sick", col=sick.colors) #, zlim = c(0, 0.05))
#dev.off()
contour(f.sick, xlab = "sick", add=TRUE)
contours.sick <- contourLines(f.sick)
length(contours.sick)  # 15

level.healthy <- 1
level.sick <- 5
contour.sick <- contours.sick[[level.sick]]
lapply(contour.sick, length)   # 1, 393, 393

x = contour.sick$x
y = contour.sick$y
x <- c(x, x[1])
y <- c(y, y[1])

mtx.sick <- matrix(c(x, y), ncol=2, byrow=FALSE)
poly = st_polygon(list(mtx.sick))
st_area(poly) # 3.578076e-06


contour.healthy <- contours.healthy[[level.healthy]]
lapply(contour.healthy, length)   # 1, 393, 393

x = contour.healthy$x
y = contour.healthy$y
x <- c(x, x[1])
y <- c(y, y[1])

mtx.healthy <- matrix(c(x, y), ncol=2, byrow=FALSE)
poly = st_polygon(list(mtx.healthy))
st_area(poly)   # 1.020345e-05

# sick area is about 35% of healthy area
3.578076e-06/ 1.020345e-05  # [1] 0.3506732

#     one degree of latitude equals 364k feet (69 miles)
#        364000 * 0.000
#	  one degree of longitute:
#			 at equator 69 miles
#            at 38:  54.6
#            at 40:  53
#			 at 47.5:  46.5 miles
# 43560 sq ft per acre

acresPerSewardSqDegree = (46.5 * 5280) * (69 * 5280) / 43560

3.578076e-06 * acresPerSewardSqDegree   # 7.35
1.020345e-05 * acresPerSewardSqDegree   # 20.95

# graveyard, final boundary: 3.578076e-06 * acresPerSewardSqDegree   # 7.35 acres
#    garden, final boundary: 1.020345e-05 * acresPerSewardSqDegree   # 20.95 acres

# https://gis.stackexchange.com/questions/28130/convert-area-from-square-meters-to-degrees-globally
# 111,194.9 square meters per square degree
# 2.47105 acres per hectare
# seattle is at 47.61 degrees north

1.020345e-05 * 111194.9  * 2.47105 # 1.134572
3.578076e-06 * 111194.9  * 2.57105 # 0.3978538

