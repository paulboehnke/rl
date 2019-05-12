include(FindPackageHandleStandardArgs)
include(GNUInstallDirs)
include(SelectLibraryConfigurations)

foreach(PATH ${CMAKE_PREFIX_PATH})
	file(
		GLOB
		HINTS
		${PATH}/${CMAKE_INSTALL_INCLUDEDIR}
		${PATH}/liblzma*/${CMAKE_INSTALL_INCLUDEDIR}
	)
	list(APPEND LIBLZMA_INCLUDE_HINTS ${HINTS})
endforeach()

list(
	APPEND
	LIBLZMA_INCLUDE_HINTS
	$ENV{LibLZMA_DIR}/${CMAKE_INSTALL_INCLUDEDIR}
)

foreach(PATH $ENV{CMAKE_PREFIX_PATH})
	file(
		GLOB
		HINTS
		${PATH}/${CMAKE_INSTALL_INCLUDEDIR}
		${PATH}/liblzma*/${CMAKE_INSTALL_INCLUDEDIR}
	)
	list(APPEND LIBLZMA_INCLUDE_HINTS ${HINTS})
endforeach()

foreach(PATH $ENV{PATH})
	file(
		GLOB
		HINTS
		${PATH}/../${CMAKE_INSTALL_INCLUDEDIR}
	)
	list(APPEND LIBLZMA_INCLUDE_HINTS ${HINTS})
endforeach()

file(
	GLOB
	LIBLZMA_INCLUDE_PATHS
	$ENV{HOME}/include
	/usr/local/include
	/opt/local/include
	/usr/include
	${CMAKE_OSX_SYSROOT}/usr/include
)

find_path(
	LIBLZMA_INCLUDE_DIRS
	NAMES
	lzma.h
	HINTS
	${LIBLZMA_INCLUDE_HINTS}
	PATHS
	${LIBLZMA_INCLUDE_PATHS}
)

mark_as_advanced(LIBLZMA_INCLUDE_DIRS)

foreach(PATH ${CMAKE_PREFIX_PATH})
	file(
		GLOB
		HINTS
		${PATH}/${CMAKE_INSTALL_LIBDIR}
		${PATH}/liblzma*/${CMAKE_INSTALL_LIBDIR}
	)
	list(APPEND LIBLZMA_LIBRARY_HINTS ${HINTS})
endforeach()

list(
	APPEND
	LIBLZMA_LIBRARY_HINTS
	$ENV{LibLZMA_DIR}/${CMAKE_INSTALL_LIBDIR}
)

foreach(PATH $ENV{CMAKE_PREFIX_PATH})
	file(
		GLOB
		HINTS
		${PATH}/${CMAKE_INSTALL_LIBDIR}
		${PATH}/liblzma*/${CMAKE_INSTALL_LIBDIR}
	)
	list(APPEND LIBLZMA_LIBRARY_HINTS ${HINTS})
endforeach()

foreach(PATH $ENV{PATH})
	file(
		GLOB
		HINTS
		${PATH}/../${CMAKE_INSTALL_LIBDIR}
	)
	list(APPEND LIBLZMA_LIBRARY_HINTS ${HINTS})
endforeach()

file(
	GLOB
	LIBLZMA_LIBRARY_PATHS
	$ENV{HOME}/lib
	/usr/local/lib
	/opt/local/lib
	/usr/lib
)

find_library(
	LIBLZMA_LIBRARY_DEBUG
	NAMES
	liblzmad lzmad
	HINTS
	${LIBLZMA_LIBRARY_HINTS}
	PATHS
	${LIBLZMA_LIBRARY_PATHS}
)
find_library(
	LIBLZMA_LIBRARY_RELEASE
	NAMES
	liblzma lzma
	HINTS
	${LIBLZMA_LIBRARY_HINTS}
	PATHS
	${LIBLZMA_LIBRARY_PATHS}
)

select_library_configurations(LIBLZMA)

find_package_handle_standard_args(
	LibLZMA
	FOUND_VAR LIBLZMA_FOUND
	REQUIRED_VARS LIBLZMA_INCLUDE_DIRS LIBLZMA_LIBRARIES
)

if(LIBLZMA_FOUND AND NOT TARGET LibLZMA::LibLZMA)
	add_library(LibLZMA::LibLZMA UNKNOWN IMPORTED)
	
	if(LIBLZMA_LIBRARY_RELEASE)
		set_property(TARGET LibLZMA::LibLZMA APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
		set_target_properties(LibLZMA::LibLZMA PROPERTIES IMPORTED_LOCATION_RELEASE "${LIBLZMA_LIBRARY_RELEASE}")
	endif()
	
	if(LIBLZMA_LIBRARY_DEBUG)
		set_property(TARGET LibLZMA::LibLZMA APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
		set_target_properties(LibLZMA::LibLZMA PROPERTIES IMPORTED_LOCATION_DEBUG "${LIBLZMA_LIBRARY_DEBUG}")
	endif()
	
	set_target_properties(
		LibLZMA::LibLZMA PROPERTIES
		INTERFACE_INCLUDE_DIRECTORIES "${LIBLZMA_INCLUDE_DIRS}"
	)
endif()
