#!/usr/bin/env groovy
@Library('Main@master')
import library.Main.*
import hudson.model.*
import hudson.EnvVars
import groovy.transform.Field
//////////////////////////////////////////
nio = new api.nio()
//////////////////////////////////////////
@Field def REPOSITORY = "tools4Bibi"
//////////////////////////////////////////
//////////////////////////////////////////
if (env.BRANCH_NAME.startsWith("release") ||
    env.BRANCH_NAME.startsWith("develop") ||
    env.BRANCH_NAME.startsWith("master")) {
    SLAVES=["Debian","Windows","MacOS","Ubuntu"]
    PLATFORMS=["Debian","Windows","MacOS","Ubuntu","Android","iOS"]
}
else
{
    SLAVES=["Debian","Windows","MacOS"]
    PLATFORMS=["Debian","Windows","MacOS","Android","iOS"]
}
//////////////////////////////////////////
//////////////////////////////////////////
//    SLAVES=["MacOS"]
//    PLATFORMS=["Android","iOS"]
//////////////////////////////////////////
//////////////////////////////////////////
lock(REPOSITORY){
    stage('Start'){
        echo 'starting...'
    }

    stage('SCM'){
       
    }

    GLOBAL_VARS = nio.getGlobalVar(REPOSITORY)
    xxx.notify('start',GLOBAL_VARS)
    nio.stashAllDependencies(GLOBAL_VARS,PLATFORMS)

    stage('SetUp'){
        nio.setAllWorkspace(PLATFORMS,GLOBAL_VARS)
    }

    stage('Build'){
        nio.execAll(PLATFORMS,GLOBAL_VARS,"default","false")
    }

    stage('Build - Samples'){
        nio.execAll(PLATFORMS,GLOBAL_VARS,"Samples","false")
    }

    stage('Archive'){
        nio.stashAllArchives(PLATFORMS,GLOBAL_VARS)
    }

    stage('Deploy'){
        nio.deployAll(PLATFORMS,GLOBAL_VARS)
    }

    stage('End'){
        nio.notify('success',GLOBAL_VARS)
    }
}