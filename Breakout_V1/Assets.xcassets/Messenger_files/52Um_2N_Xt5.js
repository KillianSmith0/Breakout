if (self.CavalryLogger) { CavalryLogger.start_js(["6\/Vhd"]); }

__d('DebouncedMentionsTextEditor.react',['AbstractMentionsTextEditor.react','clearImmediate','debounce','setImmediate'],(function a(b,c,d,e,f,g){var h,i;h=babelHelpers.inherits(j,c('AbstractMentionsTextEditor.react'));i=h&&h.prototype;function j(k){'use strict';i.constructor.call(this,k);this.__maybeSearch=function(){var l,m=this,n=this.props.editorState,o=n.getSelection();if(o.getHasFocus()&&o.isCollapsed())(function(){var p=n.getCurrentContent(),q=m.props.mentionsSource;if(q){if(m.$DebouncedMentionsTextEditor1)c('clearImmediate')(m.$DebouncedMentionsTextEditor1);m.$DebouncedMentionsTextEditor1=c('setImmediate')(function(){q.search(p,o,this.__onShowMentions);}.bind(m));}})();}.bind(this);this.__debouncedSearch=c('debounce')(this.__maybeSearch,50);}j.prototype.componentDidUpdate=function(k){'use strict';if(this.props.editorState!==k.editorState)this.__debouncedSearch();};j.prototype.componentWillUnmount=function(){'use strict';if(this.$DebouncedMentionsTextEditor1)c('clearImmediate')(this.$DebouncedMentionsTextEditor1);i.componentWillUnmount.call(this);};f.exports=j;}),null);