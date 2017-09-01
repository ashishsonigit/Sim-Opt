library(Rglpk)
xc = 8*14 # fulltime consultant cost $14/hr or $14*8 for 2 consecutive 4 hour shifts 
yc = 4*12 # parttime consultant cost $12/hr or $12*4 per 4 hour shift

obj<- c(xc,xc,xc,yc,yc,yc,yc)

# Part-time consultants can be hired to work on any of the four shifts.
# say y1,y2,y3,y4
# full-time consultants work for eight consequtive hours ie: 
# morning (8AM-4PM), say x1
# afternoon(noon-8PM), say x2
# evening(4PM-midnight), say x3


# Constraints
# x1 + y1 >= 6
# x1 + x2 + y2 >= 8
# x2 + x3 + y3 >= 12
# x3 + y4 >= 6

# x1 >= 2*y1
# x1+x2 >= 2*y2
# x2+x3 >= 2*y3
# x3 >= 2*y4


mat<- t(matrix(c(1,0,0, 1, 0, 0, 0,
                 1,1,0, 0, 1, 0, 0,
                 0,1,1, 0, 0, 1, 0,
                 0,0,1, 0, 0, 0, 1,
                 1,0,0,-2, 0, 0, 0,
                 1,1,0, 0,-2, 0, 0,
                 0,1,1, 0, 0,-2, 0,
                 0,0,1, 0, 0, 0,-2),nrow=7))
dir <- c(">=", ">=", ">=", ">=", ">=", ">=", ">=", ">=")
rhs <- c(6,8,12,6,0,0,0,0)
max <- FALSE # minimise the objective function
types <- c("I", "I", "I", "I", "I", "I", "I")

ans <- Rglpk_solve_LP(obj, mat, dir, rhs, types = types, max = max)
minimum_totalcost_hiringconsultants <- ans$optimum
fulltime_Consultant_per_8hour_shift <- ans$solution[1:3]
parttime_Consultant_per_4hour_shift <- ans$solution[4:length(ans$solution)]
