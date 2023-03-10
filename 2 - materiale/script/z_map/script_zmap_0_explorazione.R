
rm(list=ls())
setwd("./materiale/events recording")
load("../workspaces/zmap.RData")

N=length(labels)
ns=3    #numero soggetto di riferimento, poi far? forse un ciclo

#trovo le regioni dove ho in media una maggiore connettivita'
{
  v=matrix(0,83,2)
  for( i in 1:N ){
    j=labels[i]
    v[j,1] =v[j,1]+z_map[ns,i]
    v[j,2] = v[j,2]+1
    }
  v=as.data.frame(v)
  nomi=c()
  for( j  in 1:83){
    v[j,1]=v[j,1]/v[j,2]
    nomi = c(nomi,paste("reg",j, sep=""))
  }
  row.names(v)=nomi
}

mc_reg<-v
mc_reg
{ 
  # x11()
  barplot(v[,1], names.arg=row.names(v))
}

mc_reg_ord <- v[order(v[,1]), ]
mc_reg_ord


# mean connectivity control
num_control=125
mc_control = colMeans(z_map[1:125, ], na.rm=TRUE)
mc_schz = colMeans(z_map[126:175, ], na.rm=TRUE)

{ 
  # x11()
  par(mfrow=c(1,2))
  boxplot(mc_control)
  boxplot(mc_schz)
}

# 5)
#trovo le regioni dove ho in media una maggiore connettivita' nei control
{
  regioni=matrix(0,83,2)
  for( i in 1:N ){
    j=labels[i]
    regioni[j,1] =regioni[j,1]+mc_control[i]
    regioni[j,2] = regioni[j,2]+1
  }
  regioni=as.data.frame(regioni)
  nomi=c()
  for( j  in 1:83){
    regioni[j,1]=regioni[j,1]/regioni[j,2]
    nomi = c(nomi,paste("reg",j, sep=""))
  }
  row.names(regioni)=nomi
  regioni
  regioni_control <- regioni
  { x11()
    barplot(regioni[,1], names.arg=row.names(regioni))
  }
  regioni_ord <- regioni[order(regioni[,1]), ]
  regioni_ord
}


# 5.2)
#trovo le regioni dove ho in media una maggiore connettivita' nei control
{
  regioni=matrix(0,83,2)
  for( i in 1:N ){
    j=labels[i]
    regioni[j,1] =regioni[j,1]+mc_schz[i]
    regioni[j,2] = regioni[j,2]+1
  }
  regioni=as.data.frame(regioni)
  nomi=c()
  for( j  in 1:83){
    regioni[j,1]=regioni[j,1]/regioni[j,2]
    nomi = c(nomi,paste("reg",j, sep=""))
  }
  row.names(regioni)=nomi
  regioni
  regioni_schz <- regioni
  { x11()
    barplot(regioni[,1], names.arg=row.names(regioni))
  }
  regioni_ord <- regioni[order(regioni[,1]), ]
  regioni_ord
}

######
#riassunto

{ x11()
  par(mfrow=c(3,1))
  barplot(regioni_control[,1], names.arg=row.names(regioni_control), main="Connettivit? control")
  barplot(regioni_schz[,1], names.arg=row.names(regioni_schz), main="Connettivit? schz")
  barplot((-regioni_schz[,1]+regioni_control[,1]), names.arg=row.names(regioni_schz), main="Differenza totale control-schz")
}

diff=(-regioni_schz[,1]+regioni_control[,1])/(regioni_control[,1])
{x11()
  par(mfrow=c(2,1))
  barplot((-regioni_schz[,1]+regioni_control[,1]), names.arg=row.names(regioni_schz), main="Differenza totale control-schz")
  barplot((-regioni_schz[-78,1]+regioni_control[-78,1])/(regioni_control[-78,1]), names.arg=row.names(regioni_schz[-78,]), main="Differenza percentuale control-schz")
  abline(a=0.5,b=0,lty=2,col='red')
  abline(a=-0.5,b=0,lty=2,col='red')
}

#guardiamo solo le regioni con connettivi
quali = which((-regioni_schz[,1]+regioni_control[,1])/(regioni_control[,1])>0.5)
print("devo ignorare il 78 credo")
quali = c(quali,which((-regioni_schz[,1]+regioni_control[,1])/(regioni_control[,1])< -0.5))

print("IN positivo: Straight gyrus, Medial orbital gyrus, Subgenual frontal cortex,Subcallosal area")
print("in negativo Lateral ventricle (excluding temporal horn)")

save(list = c("z_map", "labels", "names_regions", "directions"), file = "../workspaces/zmap.RData")

graphics.off()

