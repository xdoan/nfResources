#format tables for jhu paper

require(synapser)
synLogin()

tab1=c()

require(tidyverse)


##do the following for data release
if(FALSE){
  update<-synTableQuery("SELECT id,assay,parentId from syn13363852 where sciDataRelease=true")$asDataFrame()
  rna.parent.id='syn19522967'
  exome.parent.id='syn19226800'
  sapply(subset(update,assay=='rnaSeq')$id,function(x){
    print(x)
    ent=synGet(x,downloadFile=FALSE)
    ent$properties$parentId=rna.parent.id
    synStore(ent)})
  
  sapply(subset(update,assay=='exomeSeq')$id,function(x){
    print(x)
    ent=synGet(x,downloadFile=FALSE)
    ent$properties$parentId=exome.parent.id
    synStore(ent)})
}

tab<-synTableQuery("SELECT distinct individualID,specimenID,sex,tumorType,organ,transplantationType,isCellLine,assay FROM syn13363852 WHERE ( ( \"resourceType\" = 'experimentalData' ) AND ( \"isMultiIndividual\" = 'false' ) AND (\"sciDataRelease\" = 'true') AND (\"fileFormat\" = 'fastq' OR \"fileFormat\" = 'cram'))")$asDataFrame()

assay.sum<-tab%>%group_by(specimenID)%>%summarize(assays=paste(unique(assay),collapse=','))

dat.tab<-tab%>%select(-assay)%>%unique()%>%left_join(assay.sum,by='specimenID')
dat.tab$tumorType[is.na(dat.tab$tumorType)]<-'Blood'
dat.tab$isCellLine<-sapply(dat.tab$isCellLine,function(x) ifelse(x,"X",""))
dat.tab$isXenograft<-sapply(dat.tab$transplantationType,function(x) ifelse(is.na(x),"","X"))

res<-dat.tab%>%select(individualID,sex,tumorType,isCellLine,isXenograft,assays,specimenID)
write.table(res,'jhuPubRawClinicalDat.tsv',sep='\t')


tab<-synTableQuery("SELECT distinct individualID,specimenID,sex,tumorType,organ,transplantationType,isCellLine,assay FROM syn13363852 WHERE ( ( \"resourceType\" = 'experimentalData' ) AND ( \"isMultiIndividual\" = 'false' ) AND (\"sciDataRelease\" = 'true') AND (\"fileFormat\" = 'fastq' OR \"fileFormat\" = 'vcf'))")$asDataFrame()

assay.sum<-tab%>%group_by(specimenID)%>%summarize(assays=paste(unique(assay),collapse=','))

dat.tab<-tab%>%select(-assay)%>%unique()%>%left_join(assay.sum,by='specimenID')
dat.tab$tumorType[is.na(dat.tab$tumorType)]<-'Blood'
dat.tab$isCellLine<-sapply(dat.tab$isCellLine,function(x) ifelse(x,"X",""))
dat.tab$isXenograft<-sapply(dat.tab$transplantationType,function(x) ifelse(is.na(x),"","X"))

res<-dat.tab%>%select(individualID,sex,tumorType,isCellLine,isXenograft,assays,specimenID)
write.table(res,'jhuPubProcClinicalDat.tsv',sep='\t')



tab<-synTableQuery("SELECT distinct individualID,specimenID,sex,tumorType,organ,transplantationType,isCellLine,assay FROM syn13363852 WHERE ( ( \"resourceType\" = 'experimentalData' ) AND ( \"isMultiIndividual\" = 'false' ) AND (\"fileFormat\" = 'fastq' OR \"fileFormat\" = 'cram') )")$asDataFrame()

assay.sum<-tab%>%group_by(specimenID)%>%summarize(assays=paste(unique(assay),collapse=','))

dat.tab<-tab%>%select(-assay)%>%unique()%>%left_join(assay.sum,by='specimenID')
dat.tab$tumorType[is.na(dat.tab$tumorType)]<-'Blood'
dat.tab$isCellLine<-sapply(dat.tab$isCellLine,function(x) ifelse(x,"X",""))
dat.tab$isXenograft<-sapply(dat.tab$transplantationType,function(x) ifelse(is.na(x),"","X"))

res<-dat.tab%>%select(individualID,sex,tumorType,isCellLine,isXenograft,assays,specimenID)
write.table(res,'AlljhuRawClinicalDat.tsv',sep='\t')


tab<-synTableQuery("SELECT distinct individualID,specimenID,sex,tumorType,organ,transplantationType,isCellLine,assay FROM syn13363852 WHERE ( ( \"resourceType\" = 'experimentalData' ) AND ( \"isMultiIndividual\" = 'false' ) AND (\"fileFormat\" = 'fastq' OR \"fileFormat\" = 'vcf') )")$asDataFrame()

assay.sum<-tab%>%group_by(specimenID)%>%summarize(assays=paste(unique(assay),collapse=','))

dat.tab<-tab%>%select(-assay)%>%unique()%>%left_join(assay.sum,by='specimenID')
dat.tab$tumorType[is.na(dat.tab$tumorType)]<-'Blood'
dat.tab$isCellLine<-sapply(dat.tab$isCellLine,function(x) ifelse(x,"X",""))
dat.tab$isXenograft<-sapply(dat.tab$transplantationType,function(x) ifelse(is.na(x),"","X"))

res<-dat.tab%>%select(individualID,sex,tumorType,isCellLine,isXenograft,assays,specimenID)
write.table(res,'AlljhuProcClinicalDat.tsv',sep='\t')
