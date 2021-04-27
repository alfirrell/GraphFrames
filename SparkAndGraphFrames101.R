# install.packages("tidyverse")
# 
# install.packages("sparklyr")
# install.packages("graphframes")

library(sparklyr)
library(graphframes)
library(stringr)

#spark_install()

## Shift over the graphframes jars into the SPARK_HOME jar dir
spark_home <- Sys.getenv("SPARK_HOME")
spark_jar_dir <- file.path(spark_home, "jars")
spark_jars <- list.files(spark_jar_dir)
if (!any(str_starts(spark_jars, "graphframes"))) {
  spark_version <- spark_version_from_home(spark_home)
  if (str_starts(spark_version, "2.4")) {
    file.copy(file.path("jars/graphframes-0.8.0-spark2.4-s_2.11.jar", spark_jar_dir))
  } else if (str_starts(spark_version, "3.0")) {
    file.copy(file.path("jars/graphframes-0.8.0-spark3.0-s_2.12.jar", spark_jar_dir)) 
  }
}



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
