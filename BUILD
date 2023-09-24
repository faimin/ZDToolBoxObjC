load("@build_bazel_rules_apple//apple:ios.bzl", "ios_application")
package(default_visibility = ["//visibility:public"])
# load(
#     "@rules_xcodeproj//xcodeproj:deps.bzl",
#     "top_level_target",
#     "xcodeproj",
# )

objc_library(
    name = "ZDMacro",
    srcs = glob([
        "ZDToolBoxObjC/Classes/ZDMacro/**/*.m",
    ]),
    hdrs = glob(["ZDToolBoxObjC/Classes/ZDMacros/**/*.h"]),
    enable_modules = 1,
    visibility = ["//visibility:public"],
)

objc_library(
    name = "ZDCommonTool",
    srcs = glob([
        "ZDToolBoxObjC/Classes/ZDCommonTool/**/*.m",
    ]),
    hdrs = glob(["ZDToolBoxObjC/Classes/ZDCommonTool/**/*.h"]),
    enable_modules = 1,
    visibility = ["//visibility:public"],
)

objc_library(
    name = "ZDProxy",
    srcs = glob([
        "ZDToolBoxObjC/Classes/ZDProxy/**/*.m",
    ]),
    hdrs = glob(["ZDToolBoxObjC/Classes/ZDProxy/**/*.h"]),
    includes = ["**/*.h"],
    enable_modules = 1,
    visibility = ["//visibility:public"],
)

objc_library(
    name = "ZDCategory",
    srcs = glob([
        "ZDToolBoxObjC/Classes/ZDCategory/**/*.m",
    ]),
    hdrs = glob(["ZDToolBoxObjC/Classes/ZDCategory/**/*.h"]),
    sdk_frameworks = [
        "UIKit",
        "Foundation"
    ],
    enable_modules = 1,
    visibility = ["//visibility:public"],
    deps = [":ZDMacro"],
)

objc_library(
    name = "ZDSubclass",
    srcs = glob([
        "ZDToolBoxObjC/Classes/ZDSubclass/**/*.m",
    ]),
    hdrs = glob(["ZDToolBoxObjC/Classes/ZDSubclass/**/*.h"]),
    includes = ["**/*.h"],
    sdk_frameworks = [
        "UIKit",
        "Foundation"
    ],
    enable_modules = 1,
    visibility = ["//visibility:public"],
    deps = [":ZDProxy"],
)

objc_library(
    name = "ZDTools",
    srcs = glob([
        "ZDToolBoxObjC/Classes/ZDTools/**/*.m",
    ]),
    hdrs = glob(["ZDToolBoxObjC/Classes/ZDTools/**/*.h"]),
    includes = ["**/*.h"],
    sdk_frameworks = [
        "UIKit",
        "Foundation"
    ],
    enable_modules = 1,
    visibility = ["//visibility:public"],
)

objc_library(
    name = "ZDHook",
    srcs = glob([
        "ZDToolBoxObjC/Classes/ZDHook/**/*.m",
    ]),
    hdrs = glob(["ZDToolBoxObjC/Classes/ZDHook/**/*.h"]),
    enable_modules = 1,
    visibility = ["//visibility:public"],
)

objc_library(
    name = "ZDAll",
    srcs = glob([
        "ZDToolBoxObjC/Classes/ZDAll/**/*.m",
    ]),
    hdrs = glob(["ZDToolBoxObjC/**/*.h"]),
    enable_modules = 1,
    visibility = ["//visibility:public"],
    deps = [
        ":ZDCategory",
        ":ZDCommonTool",
        ":ZDMacro",
        ":ZDProxy",
        ":ZDSubclass",
        ":ZDTools",
    ],
)

ios_application(
    name = "ios-tool-box-objc",
    bundle_id = "org.cocoapods.demo.ZDToolBoxObjC-Example",
    families = [
        "iphone",
    ],
    infoplists = [":Example/ZDToolBoxObjC/ZDToolBoxObjC-Info.plist"],
    launch_storyboard = "Example/ZDToolBoxObjC/Base.lproj/LaunchScreen.storyboard",
    minimum_os_version = "11.0",
    visibility = ["//visibility:public"],
    deps = [":ZDAll"],
)
