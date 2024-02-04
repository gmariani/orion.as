
set asdoc_bin="C:\Program Files\Adobe\Flex Builder 3\sdks\3.2.0\bin\asdoc.exe"
set title="Orion 1.0 API Documentation"
set footer="Copyright 2009 Gabriel Mariani (https://mariani.life/projects/orion/)"

set ext_lib_path="H:\SVN\CourseVector\global\as3\classes"
set src_path=./src/
set doc_src=src\cv H:\SVN\CourseVector\global\as3\classes\cv\util\MathUtil.as H:\SVN\CourseVector\global\as3\classes\cv\util\GeomUtil.as

%asdoc_bin% -source-path %src_path% -library-path %ext_lib_path% -main-title %title% -window-title %title% -footer %footer% -doc-sources %doc_src% -output doc -keep-xml

pause