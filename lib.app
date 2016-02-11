module elib/elib-ace/lib

section ace editor

  // https://github.com/ajaxorg/ace/wiki/Embedding---API
  
  // usage:
  // form{
  //   ace(foo.code, "foo") // to edit text value of foo.code, use "foo" once per page
  // }
  
  // make sure to add the following to css
  //   #editor<foo> {
  //     position: relative;
  //     width: 100%;
  //     height: 300px;
  //     border: 1px solid black;
  //   }
  
  define requireACE(lang : String) {
  	includeJS("src/ace.js?1")
  	case(lang.toLowerCase()) {
  		"scala" {includeJS("src/mode-scala.js?1")}
  		"java" {includeJS("src/mode-java.js?1")}
  		"c" {includeJS("src/mode-c_cpp.js?1")}
		"js" {includeJS("src/mode-javascript.js?1")}
      	"sql" {includeJS("src/mode-sql.js?1")}
		"css" {includeJS("src/mode-css.js?1")}
		"html" {includeJS("src/mode-html.js?1")}
    }
    includeJS("src/theme-eclipse.js?1") 
    includeJS("initACE.js?1")
  }
  
  define ace(code: Ref<Text>, lang : String) {  	
  	ace(code, lang, id, false)
  }
  
  define ace(code: Ref<Text>, lang : String, readonly: Bool) { 
  	ace(code, lang, id, readonly)
  }
  
  define ace(code: Ref<Text>, lang : String, idAttr: String) {  	
  	ace(code, lang, idAttr, false)
  }

  define aceView(code: Ref<Text>, lang : String) {  	
  	ace(code, lang, id, true)
  }
    
  define aceView(code: Ref<Text>, lang : String, idAttr: String) {  	
  	ace(code, lang, idAttr, true)
  }
  
  // 619px; height: 500px
  // todo: adapt size to window document.documentElement.clientWidth
  
  define ace(code: Ref<Text>, lang : String, idAttr: String, readonly: Bool) {
  	requireACE(lang) 
  	div[class="aceContainer"]{
	  	div[class="aceEditor", id="editor" + idAttr, 
	  	    style="border: 1px solid #999;"
	  	]{
	  	  output(code)
	  	}
  	}

  	input(code)[style="display:none",id=idAttr]
  	case(lang.toLowerCase()) {
  		"scala" {
  			<script>
      		registerOnload(function() { scalaEditor('~idAttr', ~readonly) });
    		</script>
  		}
  		"java" {
  			<script>
      		registerOnload(function() { javaEditor('~idAttr', ~readonly) });
    		</script>
  		}
  		"c" {
  			<script>
      		registerOnload(function() { cEditor('~idAttr', ~readonly) });
    		</script>
  		}
		"js" {
            <script>
            registerOnload(function() { jsEditor('~idAttr', ~readonly) });
            </script>
      	}
      	"sql" {
            <script>
            registerOnload(function() { sqlEditor('~idAttr', ~readonly) });
            </script>
      	}
		"css" {
            <script>
	        registerOnload(function() { cssEditor('~idAttr', ~readonly) });
	        </script>
        }
		"html" {
            <script>
	        registerOnload(function() { htmlEditor('~idAttr', ~readonly) });
	        </script>
        }
  	}
    // <script>
    //   registerOnload(function() { scalaEditor('~idAttr', ~readonly) });
    // </script>
  }