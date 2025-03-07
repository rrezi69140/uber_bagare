allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.3.10'  // Vérifie la dernière version ici : https://firebase.google.com/docs/android/setup
    }
}

apply plugin: 'com.google.gms.google-services'

android {
    compileSdkVersion 33  // Vérifie la version la plus récente

    defaultConfig {
        minSdkVersion 21  // Firebase Messaging requiert min 21
        targetSdkVersion 33
    }
}

