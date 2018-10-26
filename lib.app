module elib/elib-ace/lib

section ace editor

  // https://github.com/ajaxorg/ace/wiki/Embedding---API
  
  // usage:
  // form{
  //   codeEditor(foo.code, "foo", false) // to edit text value of foo.code, use "foo" once per page
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
    includeJS("src/mode-" + lang + ".js?1")
    includeJS("src/theme-eclipse.js?1") 
    includeJS("initACE.js?3")
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
  	var normalizedLang: String := getAceLanguageId(lang)
  	requireACE(normalizedLang) 
  	div[class="editorContainer"]{
	  	div[class="aceEditor", id="aceEditor_" + idAttr, 
	  	    style="border: 1px solid #999;"
	  	]{
	  	  output(code)
	  	}
  	}
  	input(code)[style="display:none",id=idAttr]
    <script>
      registerOnload( function(){
      	createAceEditor('~idAttr', ~readonly, '~normalizedLang')
      } );
    </script>
  }

function getAceLanguageId( language: String ): String {
  case( language.toLowerCase() ){
    "scala"    { return "scala"; }
    "scala212" { return "scala"; }
    "java"     { return "java"; }
    "java8"    { return "java"; }
    "c"        { return "c_cpp"; }
    "js"       { return "javascript"; }
    "sql"      { return "sql"; }
    "css"      { return "css"; }
    "html"     { return "html"; }
    "python"   { return "python"; }
    "python2"  { return "python"; }
    "python3"  { return "python"; }
    default    { return "plain_text"; }
  }
}