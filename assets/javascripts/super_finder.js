// Some portions of the code (related to keypress events) are inspired 
// one of the jquery autocomplete plugin
// (http://www.pengoworks.com/workshop/jquery/autocomplete.htm)

function SuperFinder(options) {
	var self = this;

	this.options = jQuery.extend({}, SuperFinder.DEFAULTS, options || {});

	this.input = jQuery('#superfinder input[name=q]');
	this.list = jQuery("#superfinder ul");

	// Find -> Command T
	jQuery(window).keypress(function(event) {
		// console.log("keypressed " + event.which + ", " + event.altKey);
		if (!(event.which == 8224 && event.altKey)) return true;
		self.open();
		event.preventDefault();
		return false;
	});
	
	jQuery(this.options.button).click(function(event) {
		self.open();
		event.preventDefault();
		return false;
	});
	
	this.input.attr("autocomplete", "off")
	.keydown(function(e) {
		// track last key pressed
		self.lastKeyPressCode = e.keyCode;
		switch(e.keyCode) {
			case 27: // ESC
				e.preventDefault();
				self.input.blur();
				self.close();
			case 38: // up
				e.preventDefault();
				self.moveSelect(-1);
				break;
			case 40: // down
				e.preventDefault();
				self.moveSelect(1);
				break;
			case 9:  // tab
				e.preventDefault();
				break;
			case 13: // return
				self.input.blur();
				self.selectCurrent();
				e.preventDefault();
				break;
			default:
				self.active = -1;
				if (self.timeout) clearTimeout(self.timeout);
				self.timeout = setTimeout(function(){ self.onChange(); }, 400);
				break;
		}
	});	
};

jQuery.extend(SuperFinder, {
	
	DEFAULTS: {
		title: 'Finder',
		limit: 6,
		maxWordSize: 15,
		button: []
	}
	
});

SuperFinder.prototype = {
	
	open: function() {
		if (this.boxy == null) {
			this.boxy = new Boxy(jQuery('#superfinder'), { 
				title: this.options.title,
				closeText: "<img src=\"/images/super_finder/close.png\" alt=\"[close]\" />"
			});
			this.input.focus();
		} else {
			this.boxy.show();
			this.reset();
		}
	},
	
	close: function() {
		this.boxy.hide();
	},
	
	search: function(val) {
		// console.log("looking for '" + val + "'");
		var matches = [];
		
		if (val.length != 0) {
			var regexp = this.buildRegExp(val);
			for (var key in SuperFinderResources) {
				var tmp = jQuery.grep(SuperFinderResources[key], function(resource) {
					var matched = regexp.test(resource.value.toLowerCase());
					// console.log("resource.value=" + resource.value + ", label = " + key + ", matched =" + matched);					
					if (matched) resource.label = key;
					return matched;
				});				
				jQuery.merge(matches, tmp);
			}
		}
		
		this.update(matches.slice(0, this.options.limit), val);
	},
	
	selectCurrent: function() {
		var current = jQuery('li.on', this.list);
		
		if (current.size() != 0)
			window.location.href = current.find('a').attr('href');
	},
	
	update: function(matches, val) {
		var self = this;
		this.list.empty();
		
		jQuery.each(matches, function() {
			var className = this.label.toLowerCase().replace(/ /g, "-").replace(/_/g, "-");
			var name = self.highlight(val, this.value);
			
			var li = "<li class=\"" + className + "\"><label>" + this.label + "</label><a href=\"" + this.url + "\">" + name + "</a></li>";
			self.list.append(li);
		});
		
		if (matches.length > 0)
			this.moveSelect(1);
	},
	
	moveSelect: function(step) {
		var children = this.list.children();

		if (children.length == 0) return ;

		if (this.active >= 0)
			jQuery(children[this.active]).find('label').animate({ marginLeft: '0px' }, 'fast');

		this.active += step;

		if (this.active < 0) {
			this.active = 0;
		} else if (this.active >= children.size()) {
			this.active = children.size() - 1;
		}

		children.removeClass('on');
		jQuery(children[this.active]).addClass('on').find('label').animate({ marginLeft: '10px' }, 'fast');
	},
	
	onChange: function() {
		if (this.lastKeyPressCode == 46 || (this.lastKeyPressCode > 8 && this.lastKeyPressCode < 32)) return ;
		var val = this.input.val();
		if (val == this.prev) return ;
		this.prev = val;
		this.search(val);
	},
	
	reset: function() {
		this.list.empty();
		this.input.val('').focus();
		this.active = -1;
		this.prev = null;
	},
	
	highlight: function(val, word) {
		var text = "";
		for (var i = 0; i < val.length; i++) {
			var pos = word.toLowerCase().indexOf(val[i]);
			if (pos != -1) {
				text += word.slice(0, pos) + "<em>" + word[pos] + "</em>";
				if (i == val.length - 1)
					text += word.slice(pos + 1);
				else
					word = word.slice(pos + 1);
			}
		}
		return text;
	},
	
	buildRegExp: function(val) {
		var exp = "";
		for (var i = 0; i < val.length; i++) {
			exp += val[i];
			if (i < val.length - 1) exp += ".*";
		}
		return new RegExp(exp);
	}
};
