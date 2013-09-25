(function() {
  function isVisible(node) {
      return node.visible() && node.ancestors().all(function(item) {
          return item.visible()
      });
  }
	
	var elements = [];
	
	function _guessInitialMode(element) {
		var urlMatch = /^\/admin\/([a-z_-]+)/.exec(location.pathname);
		var controller = urlMatch ? urlMatch[1] : "unknown";
		
		var filterSelect = $("snippet_filter_id");
		var part = element.up(".part");
		
		if (part && !filterSelect) {
			filterSelect = part.down('select[id$=\"filter_id\"]');
		}
		
		if (filterSelect) {
			var value = filterSelect.value.toLowerCase()
			if (value == "markdown") {
				return "markdown";
			} else if (value == "haml") {
				return "haml";
			} else if (value == "") {
				return "htmlmixed";
			}
		}
		
		var sheetFilter = $("sheet_filter_id");
		
		if (sheetFilter) {
			var value = sheetFilter.value.toLowerCase();
			
			if (value == "scss") {
				return "text/x-scss";
			} else if (value == "sass") {
				return "sass";
			} else if (value == "coffee") {
				return "coffeescript";
			} else if (controller == "scripts") {
				return "javascript";
			} else if (controller == "styles") {
				return "css";
			}
		}
		
		return "null";
	}
	
	function guessInitialMode() {
		try {
			return _guessInitialMode.apply(this, arguments);
		} catch (e) {
			return "null";
		}
	}
	
	function watchVisible() {
		var toRemove = [];
		
		elements.each(function(element) {
      if (!isVisible(element)) {
        return;
      }
			
      element._codemirror = true; // don't retry
			toRemove.push(element);
      var editor = element._codemirror = CodeMirror.fromTextArea(element, {
        mode: guessInitialMode(element),
        theme: "xq-light",
        tabSize: 2,
        lineNumbers: true
      });
			
			var part = element.up(".part");
			
			if (part) {
				var filterSelect = part.down('select[id$=\"filter_id\"]');
			
				if (filterSelect) {
					filterSelect.observe("change", function() {
						var mode = "text/html";
				
						if (filterSelect.value == "Markdown") {
							mode = "text/css";
						}
				
						editor.setOption("mode", mode);
					});
				}
			}
		
			var button = new Element("button");
			button.innerText = "Format selection";
			button.observe("click", function(e) {
				Event.stop(e);
				
				var range = { from: editor.getCursor(true), to: editor.getCursor(false) };

				if (range.from.line != range.to.line || range.from.ch != range.to.ch) {
					editor.autoFormatRange(range.from, range.to);
				}
			});
			element.insert({ after: button });
			
			var modeSelect = new Element("select");
			var currentMode = editor.getMode().name;
			
			$H(CodeMirror.modes).each(function(pair) {
				if (typeof(pair.value) != 'function') {
					return;
				}
				
				var option = new Element("option");
				option.innerText = pair.key;
				option.value = pair.key;
				
				if (currentMode == pair.key) {
					option.selected = true;
				}
				
				modeSelect.insert(option);
			});
			
			modeSelect.observe("change", function() {
				editor.setOption("mode", modeSelect.value);
			});
			
			element.insert({ after: modeSelect });
		});
		
		elements = elements.without.apply(elements, toRemove);
	}

  function watchElements() {
    var i, textareas = $$("textarea.textarea.large");

    for (i = 0; i < textareas.length; i++) {
      var textarea = textareas[i];

      if (textarea._codemirror) {
        continue;
      }

			if (!textarea._watched) {
				textarea._watched = true;
			  elements.push(textarea);	
			}
    }
  }
	
	document.observe("dom:loaded", function() {
		setTimeout(watchElements, 50);
	  setInterval(watchElements, 500);
		setInterval(watchVisible, 50);
	});
})();