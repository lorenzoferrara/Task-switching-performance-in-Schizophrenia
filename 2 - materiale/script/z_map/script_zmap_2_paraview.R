
setwd("./materiale")
load("./workspaces/zmap.RData")
load("./workspaces/connectivity.map.RData")

con_reg_control=colMeans(con_reg[1:125,])
con_reg_schz=colMeans(con_reg[126:175,])

## Mean of the connectivity values on each node, in the control group and in the schizophrenic group
zmap_control = rep(0, N)
zmap_schz = rep(0, N)
for( node in 1:N ){
  zona = labels[node]
  if(zona != 0){
    zmap_control[node] = con_reg_control[zona]
    zmap_schz[node] = con_reg_schz[zona]
  }
}

{
library(fdaPDE)
library(rgl)
FEM_ctrl = FEM(zmap_control, FEMbasis)
FEM_schz = FEM(zmap_schz, FEMbasis)
FEM_diff = FEM(zmap_schz - zmap_control, FEMbasis)

if(F){
setwd("./script/z_map")
write.vtu(FEM_ctrl, file = 'zmap_control.vtu')
write.vtu(FEM_schz, file = 'zmap_schz.vtu')
write.vtu(FEM_diff, file = 'zmap_diff.vtu')
setwd("../..")
}

plot(FEM_ctrl)
rgl.snapshot("./plots/zmap_control.png", fmt="png")
plot(FEM_schz)
rgl.snapshot("./plots/zmap_schz.png", fmt="png")
plot(FEM_diff)
rgl.snapshot("./plots/zmap_diff.png", fmt="png")
}


###########################

#plotto le prime 3 PCs
pc=directions[,]
n_pcs=3

zmap_first3pc=matrix(0, nrow = n_pcs, ncol = N)
for( node in 1:N ){
  zona = labels[node]
  if(zona != 0){
    for( ind in 1:n_pcs){
      zmap_first3pc[ind, node] = pc[zona, ind]
    }
  }
}


for( i in 1:n_pcs ){
  plot(FEM(zmap_first3pc[i,], FEMbasis))
  setwd("./script/z_map")
  write.vtu(FEM(zmap_first3pc[i,], FEMbasis), file = paste('zmap_pc', i, '.vtu', sep=""))
  setwd("../..")
  rgl.snapshot( paste("plots/zmap_first3pc", i, ".png", sep=""), fmt="png")
}

###########################

#salvo anche la versione della 1^pca sottraendo la media
pc1_modificata = rep(0,N)
medie<-colMeans(con_reg)
ind=1
for( node in 1:N ){
  zona = labels[node]
  if(zona != 0){
    pc1_modificata[node] = pc[zona, ind] - medie[zona]
    }
  }
setwd("./script/z_map")
write.vtu(FEM(pc1_modificata, FEMbasis), file = paste('zmap_pc', i, 'modificata.vtu', sep=""))
setwd("../..")

########
max(zmap_first3pc)
min(zmap_first3pc)
