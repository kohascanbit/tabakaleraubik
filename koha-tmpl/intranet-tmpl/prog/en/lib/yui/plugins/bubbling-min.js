/*
=======
/*
Copyright (c) 2007, Caridy Patiño. All rights reserved.
Portions Copyright (c) 2007, Yahoo!, Inc. All rights reserved.
Code licensed under the BSD License:
http://www.bubbling-library.com/eng/licence
version: 1.4.0
*/
YAHOO.namespace("plugin","behavior");YAHOO.namespace("CMS","CMS.widget","CMS.behaviors","CMS.plugin");
(function(){var $Y=YAHOO.util,$E=YAHOO.util.Event,$D=YAHOO.util.Dom,$L=YAHOO.lang,$=YAHOO.util.Dom.get;YAHOO.Bubbling=function(){var obj={},ua=navigator.userAgent.toLowerCase(),isOpera=(ua.indexOf('opera')>-1);var navRelExternal=function(layer,args){var el=args[1].anchor;if(!args[1].decrepitate&&el){var r=el.getAttribute("rel"),t=el.getAttribute("target");if((!t||(t===''))&&(r=='external')){el.setAttribute("target","blank");}}};var defaultActionsControl=function(layer,args){obj.processingAction(layer,args,obj.defaultActions);};var _searchYUIButton=function(t){var el=obj.getOwnerByClassName(t,'yui-button'),bt=null,id=null;if($L.isObject(el)&&YAHOO.widget.Button){bt=YAHOO.widget.Button.getButton(el.id);}return bt;};obj.ready=false;obj.bubble={};obj.onReady=new $Y.CustomEvent('bubblingOnReady',obj,true);obj.getOwnerByClassName=function(node,className){return($D.hasClass(node,className)?node:$D.getAncestorByClassName(node,className));};obj.getOwnerByTagName=function(node,tagName){node=$D.get(node);if(!node){return null;}return(node.tagName&&node.tagName.toUpperCase()==tagName.toUpperCase()?node:$D.getAncestorByTagName(node,tagName));};obj.getAncestorByClassName=obj.getOwnerByClassName;obj.getAncestorByTagName=obj.getOwnerByTagName;obj.onKeyPressedTrigger=function(args,e,m){var b='key';e=e||$E.getEvent();m=m||{};m.action=b;m.target=args.target;m.decrepitate=false;m.event=e;m.stop=false;m.type=args.type;m.keyCode=args.keyCode;m.charCode=args.charCode;m.ctrlKey=args.ctrlKey;m.shiftKey=args.shiftKey;m.altKey=args.altKey;this.bubble.key.fire(e,m);if(m.stop){$E.stopEvent(e);}return m.stop;};obj.onEventTrigger=function(b,e,m){e=e||$E.getEvent();m=m||{};m.action=b;m.target=(e?$E.getTarget(e):null);m.decrepitate=false;m.event=e;m.stop=false;this.bubble[b].fire(e,m);if(m.stop){$E.stopEvent(e);}return m.stop;};obj.onNavigate=function(e){var conf={anchor:this.getOwnerByTagName($E.getTarget(e),'A'),button:_searchYUIButton($E.getTarget(e))};if(!conf.anchor&&!conf.button){conf.input=this.getOwnerByTagName($E.getTarget(e),'INPUT');}if(conf.button){conf.value=conf.button.get('value');}else if(conf.input){conf.value=conf.input.getAttribute('value');}if(!this.onEventTrigger('navigate',e,conf)){this.onEventTrigger('god',e,conf);}};obj.onProperty=function(e){this.onEventTrigger('property',e,{anchor:this.getOwnerByTagName($E.getTarget(e),'A'),button:_searchYUIButton($E.getTarget(e))});};obj._timeoutId=0;obj.onRepaint=function(e){clearTimeout(obj._timeoutId);obj._timeoutId=setTimeout(function(){var b='repaint',e={target:document.body},m={action:b,target:null,event:e,decrepitate:false,stop:false};obj.bubble[b].fire(e,m);if(m.stop){$E.stopEvent(e);}},150);};obj.onRollOver=function(e){this.onEventTrigger('rollover',e,{anchor:this.getOwnerByTagName($E.getTarget(e),'A')});};obj.onRollOut=function(e){this.onEventTrigger('rollout',e,{anchor:this.getOwnerByTagName($E.getTarget(e),'A')});};obj.onKeyPressed=function(args){this.onKeyPressedTrigger(args);};obj.onKeyListener=function(ev,args){this.onKeyPressedTrigger(args[1]);};obj.getActionName=function(el,depot){depot=depot||{};var b=null,r=null,f=($D.inDocument(el)?function(b){return $D.hasClass(el,b)}:function(b){return el.hasClass(b);});if(el&&($L.isObject(el)||(el=$(el)))){try{r=el.getAttribute("rel");}catch(e){};for(b in depot){if((depot.hasOwnProperty(b))&&(f(b)||(b===r))){return b;}}}return null;};obj.getFirstChildByTagName=function(el,t){if(el&&($L.isObject(el)||(el=$(el)))&&t){var l=el.getElementsByTagName(t);if(l.length>0){return l[0];}}return null;};obj.virtualTarget=function(e,el){if(el&&($L.isObject(el)||(el=$(el)))&&e){var t=$E.getRelatedTarget(e);if($L.isObject(t)){while((t.parentNode)&&$L.isObject(t.parentNode)&&(t.parentNode.tagName!=="BODY")){if(t.parentNode===el){return true;}t=t.parentNode;}}}return false;};obj.addLayer=function(layers,scope){var result=false;layers=($L.isArray(layers)?layers:[layers]);scope=scope||window;for(var i=0;i<layers.length;++i){if(layers[i]&&!this.bubble.hasOwnProperty(layers[i])){this.bubble[layers[i]]=new $Y.CustomEvent(layers[i],scope,true);result=true;}}return result;};obj.subscribe=function(layer,bh,scope){var first=this.addLayer(layer);if(layer){if($L.isObject(scope)){this.bubble[layer].subscribe(bh,scope,true);}else{this.bubble[layer].subscribe(bh);}}return first;};obj.on=obj.subscribe;obj.fire=function(layer,obj){obj=obj||{};obj.action=layer;obj.decrepitate=false;obj.stop=false;if(this.bubble.hasOwnProperty(layer)){this.bubble[layer].fire(null,obj);}return obj.stop;};obj.processingAction=function(layer,args,actions,force){var behavior=null,t;if(!args[1].decrepitate||force){t=args[1].anchor||args[1].input||args[1].button;if(t){behavior=this.getActionName(t,actions);args[1].el=t;}if(behavior&&(actions[behavior].apply(args[1],[layer,args]))){$E.stopEvent(args[0]);args[1].decrepitate=true;args[1].stop=true;}}};obj.defaultActions={};obj.addDefaultAction=function(n,f){if(n&&f&&(!this.defaultActions.hasOwnProperty(n))){this.defaultActions[n]=f;}};$E.addListener(window,"resize",obj.onRepaint,obj,true);obj.on('navigate',navRelExternal);obj.on('navigate',defaultActionsControl);obj.initMonitors=function(config){var fMonitors=function(){var oMonitors=new YAHOO.widget.Module('yui-cms-font-monitor',{monitorresize:true,visible:false});oMonitors.render(document.body);YAHOO.widget.Module.textResizeEvent.subscribe(obj.onRepaint,obj,true);YAHOO.widget.Overlay.windowScrollEvent.subscribe(obj.onRepaint,obj,true);};if($L.isFunction(YAHOO.widget.Module)){$E.onDOMReady(fMonitors,obj,true);}};obj.init=function(){if(!this.ready){var el=document.body;$E.addListener(el,"click",obj.onNavigate,obj,true);$E.addListener(el,(isOpera?"mousedown":"contextmenu"),obj.onProperty,obj,true);if(isOpera){$E.addListener(el,"click",obj.onProperty,obj,true);}$E.addListener(el,"mouseover",obj.onRollOver,obj,true);$E.addListener(el,"mouseout",obj.onRollOut,obj,true);$E.addListener(document,"keydown",obj.onKeyPressed,obj,true);$E.addListener(document,"keyup",obj.onKeyPressed,obj,true);this.ready=true;obj.onReady.fire();}};$E.onDOMReady(obj.init,obj,true);obj.addLayer(['navigate','god','property','key','repaint','rollover','rollout']);return obj;}();})();YAHOO.CMS.Bubble=YAHOO.Bubbling;
YAHOO.register("bubbling",YAHOO.Bubbling,{version:"1.4.0",build:"216"});
