--解决方案名称
workspace "OpenGL-Test" 
	--架构
    architecture "x64" 
    --启动项目名称
	startproject "Sandbox" 
    --构建类型
	configurations {
		"Debug",
		"Release"
	}
	 --指定编译或链接过程的标记
	flags {
        --多核并行编译
		"MultiProcessorCompile" 
	}
--全局变量,指定输出的目录
outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

--定义子项目的位置
IncludeDirs = {}
IncludeDirs["GLFW"] = "Sandbox/vendor/GLFW"
IncludeDirs["GLAD"] = "Sandbox/vendor/GLAD"
--IncludeDirs["imgui"] = "vendor/imgui"

--包含子项目,子项目中的premake5.lua会继承解决方案的premake5.lua中的全局变量
include "Sandbox/vendor/"
--include "vendor/imgui"

--下面定义启动项目 Sandbox
project "Sandbox"
	location "SandBox"
	kind "ConsoleApp" --项目类型,此处为命令行项目
	language "C++" -- 语言 c++
	cppdialect "C++17" --c++版本
    
	targetdir ("./bin/" .. outputdir .. "/%{prj.name}") --生成的目录 prj是premake内置的变量,表示项目对象
	objdir ("./bin-int/" .. outputdir .. "/%{prj.name}") --中间文件目录 prj是premake内置的变量,表示项目对象

	files { --项目的源文件
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp",
		"%{prj.name}/src/**.c",
		-- "vendor/stb_image/**.h",
		-- "vendor/stb_image/**.cpp",
		-- "vendor/glm/**.hpp",
		-- "vendor/glm/**.inl",
	}

	includedirs { --项目包含的目录
		"%{prj.name}/src",
		"%{IncludeDirs.GLFW}/include",
		"%{IncludeDirs.GLAD}/include",
		-- "vendor/imgui",
		-- "vendor/glm",
		-- "vendor/stb_image"
	}
	
	
	links { --链接的静态库
		"GLAD",
		"GLFW",
		"opengl32.lib",
		-- "ImGui"
	}

	filter "system:windows"
		cppdialect "c++17"
		staticruntime "On"
		systemversion "latest"

	filter "configurations:Debug"
		symbols "On"

	filter "configurations:Release"
		optimize "On"