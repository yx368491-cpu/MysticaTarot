allprojects {
    repositories {
        google()
        mavenCentral()
        // Aliyun mirrors last so non-China CI / collaborators get the
        // canonical google()/mavenCentral() hits first; aliyun only
        // kicks in as a fast fallback for artifacts that hit timeout
        // upstream. Removing these two lines is safe — vanilla
        // google()/mavenCentral() is still authoritative.
        maven { url = uri("https://maven.aliyun.com/repository/google") }
        maven { url = uri("https://maven.aliyun.com/repository/public") }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
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
