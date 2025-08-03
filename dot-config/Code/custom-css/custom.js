/* Debugger steps on the sidebar instead of floating */
"use strict";function l(e){return new Promise(t=>setTimeout(t,e))}async function a(e,t,n,i,o){do{let u=e();if(u!==void 0)return o?.(),u;await l(t)}while(n-- >0);i?.()}var r;function d(){r!==void 0&&(r.disconnect(),r=void 0)}function s(e){e.setAttribute("style",`
      bottom: 0;
      top: unset;
      left: 4px;
      position: fixed;
      height: 32px;
      display: flex;
      padding-left: 7px;
      box-shadow: none;
      transform: rotate(-90deg) translate(90px, 20px);
      transform-origin: left center 0px;
  `.replace(/\n|\s{2,}/g,""))}d();var c=e=>new MutationObserver(function(t){for(let n of t)if(n.type==="attributes")switch(n.attributeName){case"style":{let o=n.target.style.top;o!=="unset"&&typeof o=="string"&&(`${o}`,s(e));break}default:break}}),f=0;a(()=>{let e=document.querySelector(".debug-toolbar");return f++%4,e===null?void 0:e},500,Number.POSITIVE_INFINITY).then(e=>{e!==void 0&&(s(e),r=c(e),r.observe(e,{attributes:!0}))});


