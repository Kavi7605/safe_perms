allprojects {
    repositories {
        google()
        mavenCentral()
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

// Fix for device_apps namespace issue
subprojects {
    val subproject = this
    subproject.pluginManager.withPlugin("com.android.library") {
        if (subproject.name == "device_apps") {
            val androidExt = subproject.extensions.getByName("android")
            // Use reflection to set namespace and avoid build script errors
            val setNamespace = androidExt.javaClass.getMethod("setNamespace", String::class.java)
            setNamespace.invoke(androidExt, "com.frangsierra.deviceapps")
        }
    }
}