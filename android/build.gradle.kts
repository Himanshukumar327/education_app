// android/build.gradle.kts
//import org.gradle.api.tasks.Delete

//buildscript {
//    dependencies {
////        classpath("com.google.gms:google-services:4.4.2") // ✅ Required for Firebase
////        classpath("com.google.firebase:firebase-crashlytics-gradle:3.0.2")
////        classpath("com.google.firebase:perf-plugin:1.4.2")
//    }
//}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
