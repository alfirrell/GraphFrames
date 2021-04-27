# install.packages("tidyverse")
# 
# install.packages("sparklyr")
# install.packages("graphframes")

library(sparklyr)
library(graphframes)

#spark_install()

spark_installed_versions()
#options("SPARK_HOME")
Sys.getenv("SPARK_HOME")
sc <- spark_connect(master = "local") #, 
                    #spark_home = "C:/Users/Alastair/AppData/Local/spark/spark-3.1.1-bin-hadoop3.2")

#spark_disconnect(sc)


# Hello world -------------------------------------------------------------

# create some nodes and edges
v_tbl <- sdf_copy_to(
  sc, data.frame(id = 1:3, name = LETTERS[1:3])
)
e_tbl <- sdf_copy_to(
  sc, data.frame(src = c(1, 2, 2), dst = c(2, 1, 3),
                 action = c("love", "hate", "follow"))
)
gf <- gf_graphframe(v_tbl, e_tbl)
#gf_graphframe(edges = e_tbl)
gf

gf_degrees(gf)
gf_shortest_paths(gf)

## Test data
friends <- gf_friends(sc)
friends
gf_shortest_paths(friends, c("a", "d"))

install.packages("ggraph")
library(ggraph)

autograph(friends)
