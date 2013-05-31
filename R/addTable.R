# Method Docx.addTable 
# 
# Author: David GOHEL <david.gohel@lysis-consultants.fr>
# Date: 1 avr. 2013
# Version: 0.1
###############################################################################

setMethod("addTable", "Docx", function(x 
				, data
				, formats
				, header.labels
				, grouped.cols=list()
				, span.first.columns = 0
				, col.types
				, col.colors
				, col.fontcolors
				, ...) {
			
			#------ controls

			check.args = list()
			
			if( !missing( data ) )
				check.args$data = data
			
			if( missing( formats ) ) 
				formats = get.default.formats()
			check.args$formats = formats
			
			if( !missing( header.labels ) )
				check.args$header.labels = header.labels
			if( !missing( grouped.cols ) )
				check.args$grouped.cols = grouped.cols
			if( !missing( span.first.columns ) )
				check.args$span.first.columns = span.first.columns
			if( !missing( col.types ) )
				check.args$col.types = col.types
			if( !missing( col.colors ) )
				check.args$col.colors = col.colors
			if( !missing( col.fontcolors ) )
				check.args$col.fontcolors = col.fontcolors
			
			args = do.call( addTable.check.arg, check.args )
			
			.jformats.object = .jinitialize.TableFormat( args$formats )
			
			.jcall( x@obj , "V", "initDataTable"
					, args$span.first.columns
					, .jformats.object
			)
			
			for( j in names( args$data ) ){
				if( is.factor(args$data[, j] ) ) tempdata = as.character( args$data[, j] )
				else tempdata = args$data[, j]
				
				if( args$col.types[[j]] == "percent" )
					.jcall( x@obj , "V", "setPercentData", j, args$header.labels[[j]], .jarray(tempdata*100) )
				else if( args$col.types[[j]] == "double" )
					.jcall( x@obj , "V", "setData", j, args$header.labels[[j]], .jarray( as.double(tempdata)) )
				else if( args$col.types[[j]] == "integer" )
					.jcall( x@obj , "V", "setData", j, args$header.labels[[j]], .jarray( as.integer(tempdata)) )
				else if( args$col.types[[j]] == "character" )
					.jcall( x@obj , "V", "setData", j, args$header.labels[[j]], .jarray( as.character(tempdata)) )
				else if( args$col.types[[j]] == "date" )
					.jcall( x@obj , "V", "setData", j, args$header.labels[[j]], .jarray( format( tempdata, "%Y-%m-%d" ) ) )
				else if( args$col.types[[j]] == "datetime" )
					.jcall( x@obj , "V", "setData", j, args$header.labels[[j]], .jarray( format( tempdata, "%Y-%m-%d " ) ) )
			}#TODO: manque les dates
			
			if( length( args$grouped.cols ) > 0 ){
				for( j in names( args$grouped.cols ) ){ 
					.jcall( x@obj , "V", "setGroupedCols", j, .jarray( args$grouped.cols[[j]] ) )
				}
			}

			if( length( args$col.colors ) > 0 ){
				for( j in names( args$col.colors ) ){ 
					.jcall( x@obj , "V", "setFillColors", j, .jarray( args$col.colors[[j]] ) )
				}
			}
			
			if( length( args$col.fontcolors ) > 0 ){
				for( j in names( args$col.fontcolors ) ){ 
					.jcall( x@obj , "V", "setFontColors", j, .jarray( args$col.fontcolors[[j]] ) )
				}
			}
			
			.jcall( x@obj, "V", "addDataTable" )
			x
		})
