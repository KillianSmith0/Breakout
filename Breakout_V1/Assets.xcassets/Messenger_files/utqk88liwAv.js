if (self.CavalryLogger) { CavalryLogger.start_js(["3dvxH"]); }

__d('ChatSidebarPageItem.react',['cx','XUIBadge.react','Layout.react','Link.react','React','SplitImage.react'],(function a(b,c,d,e,f,g,h){'use strict';var i,j,k=c('Layout.react').Column,l=c('Layout.react').FillColumn,m=9;i=babelHelpers.inherits(n,c('React').Component);j=i&&i.prototype;function n(){var o,p;for(var q=arguments.length,r=Array(q),s=0;s<q;s++)r[s]=arguments[s];return p=(o=j.constructor).call.apply(o,[this].concat(r)),this.state={menuOpen:false},this.$ChatSidebarPageItem2=function(){this.setState({menuOpen:true});}.bind(this),this.$ChatSidebarPageItem1=function(){this.setState({menuOpen:false});}.bind(this),p;}n.prototype.render=function(){return c('React').createElement('div',{className:"_55ln",rel:'ignore'},c('React').createElement('div',{className:"_55lp"},c('React').createElement(c('Layout.react'),null,c('React').createElement(k,null,c('React').createElement(c('Link.react'),{href:this.props.href},c('React').createElement('div',{className:"_55lq"},c('React').createElement(c('SplitImage.react'),{size:this.props.imageSize,srcs:this.props.image})))),c('React').createElement(l,null,c('React').createElement(c('Link.react'),{className:"_224p",href:this.props.href},c('React').createElement('div',{className:"_55lr"},this.props.name))),c('React').createElement(k,{className:"_3p8_"},c('React').createElement('div',{className:"_5bon"+(this.state.menuOpen?' '+"_3p90":'')+(!this.state.menuOpen?' '+"_3p91":'')},this.renderUnreadCount(),this.renderPageActionMenu())))));};n.prototype.renderUnreadCount=function(){var o=this.props.unreadCount;if(!o)return null;return c('React').createElement(c('XUIBadge.react'),{className:"_4fsv",count:o,maxcount:m,type:'regular'});};n.prototype.renderPageActionMenu=function(){var o=this.props.popoverMenu;return c('React').createElement(o,{messageEligible:this.props.messageEligible,onHide:this.$ChatSidebarPageItem1,onShow:this.$ChatSidebarPageItem2,pageID:this.props.pageID,ref:this.props.pageRef});};f.exports=n;}),18);