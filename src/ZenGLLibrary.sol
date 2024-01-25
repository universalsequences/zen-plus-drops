
pragma solidity ^0.8.20;

contract ZenGLLibrary {
    string public data;

    constructor() {
        data = "!function(e,t){\"object\"==typeof exports&&\"object\"==typeof module?module.exports=t():\"function\"==typeof define&&define.amd?define([],t):\"object\"==typeof exports?exports.gl=t():e.gl=t()}(this,(()=>(()=>{\"use strict\";var e={d:(t,r)=>{for(var n in r)e.o(r,n)&&!e.o(t,n)&&Object.defineProperty(t,n,{enumerable:!0,get:r[n]})},o:(e,t)=>Object.prototype.hasOwnProperty.call(e,t),r:e=>{\"undefined\"!=typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(e,Symbol.toStringTag,{value:\"Module\"}),Object.defineProperty(e,\"__esModule\",{value:!0})}},t={};e.r(t),e.d(t,{DrawType:()=>oe,GLType:()=>n,abs:()=>U,add:()=>v,argument:()=>f,attribute:()=>a,call:()=>s,ceil:()=>L,cos:()=>R,cross:()=>O,defun:()=>o,div:()=>E,dot:()=>D,emitArguments:()=>u,emitAttributes:()=>i,emitFunctions:()=>l,exp:()=>G,exp2:()=>j,float:()=>de,floor:()=>x,func:()=>y,length:()=>B,mat2:()=>ue,mat3:()=>fe,mat4:()=>me,max:()=>w,min:()=>V,mix:()=>N,mod:()=>F,mount:()=>ne,mult:()=>h,normalize:()=>M,perspectiveMatrix:()=>ce,pow:()=>T,sign:()=>P,sin:()=>$,smoothstep:()=>S,sqrt:()=>C,step:()=>I,sub:()=>A,tan:()=>_,uniform:()=>be,unpack:()=>W,uv:()=>K,varying:()=>z,vec:()=>Q,vec2:()=>X,vec3:()=>J,vec4:()=>Z,vector:()=>q,viewMatrix:()=>pe,x:()=>ee,y:()=>te,zen:()=>re});const r=e=>{let t,r;return n=>{if(void 0!==t){if(r===n)return n.isVariableEmitted(t.variable)?Object.assign(Object.assign({},t),{code:t.variable}):t;{if(n.isVariableEmitted(t.variable))return Object.assign(Object.assign({},t),{code:t.variable});let e=!1;if(t.variables)for(let r of t.variables)if(n.isVariableEmitted(r)){e=!0;break}if(!e){if(t.variables)for(let e of t.variables)n.emittedVariables[e]=!0;return n.emittedVariables[t.variable]=!0,t}}}return r=n,t=e(n),t}};var n;!function(e){e[e.Mat2=0]=\"Mat2\",e[e.Mat3=1]=\"Mat3\",e[e.Mat4=2]=\"Mat4\",e[e.Float=3]=\"Float\",e[e.Vec2=4]=\"Vec2\",e[e.Vec3=5]=\"Vec3\",e[e.Vec4=6]=\"Vec4\",e[e.Sampler2D=7]=\"Sampler2D\",e[e.Function=8]=\"Function\"}(n||(n={}));const a=(e,t,n=2,a=!1)=>{let i=[],o={name:\"\",type:e,data:t,size:n,isInstance:a},s=()=>{let t=r((t=>{if(!o.name){let[e]=t.useVariables(\"attribute\");o.name=e}i.includes(t)||(i.push(t),t.attributes.push(s));let r=t.emit(e,\"\",o.name);return r.attributes||(r.attributes=[]),r.attributes.push(o),r}));return t.attribute=s,t};return s.set=e=>{o.data=e;for(let e of i)if(o.buffer){let t=e.webGLRenderingContext;t&&(t.bindBuffer(t.ARRAY_BUFFER,o.buffer),t.bufferData(t.ARRAY_BUFFER,new Float32Array(o.data),t.STATIC_DRAW))}},s.get=()=>o,s},i=(...e)=>{let t=new Set;for(let r of e)if(r.attributes)for(let e of r.attributes)t.add(e);return Array.from(t)},o=(e,t)=>{let r;return n=>{if(r)return r;let a=new c(n).gen(e),i=\"\",o={};o=Object.assign({},e);let s=a.code;return s.includes(\";\")||(s+=\";\"),i+=`\\n${s}\\n\\nreturn ${a.variable};\\n            `,r=Object.assign(Object.assign({},o),{type:a.type,variables:[],code:i,uniforms:a.uniforms,variable:t,functions:l(a),functionArguments:u(a)}),r}},s=(e,...t)=>r((r=>{let n=t.map((e=>r.gen(e)));if(\"function\"!=typeof e)return n[0];let a=e(r),i=a.variable,[o]=r.useVariables(`${i}Value`),s=`${r.printType(a.type)} ${o} = ${i}(${n.map((e=>e.variable)).join(\",\")}); \\n`,l=r.emit(a.type,s,o,...n),u=void 0===l.functions?[]:l.functions;return l.functions=[...u,a],l.uniforms=[...l.uniforms||[],...a.uniforms||[]],l})),l=(...e)=>{let t=new Set;for(let r of e)if(r.functions)for(let e of r.functions)t.add(e);return Array.from(t)},u=(...e)=>{let t=new Set;for(let r of e)if(r.functionArguments)for(let e of r.functionArguments)t.add(e);return Array.from(t)},f=(e,t,n)=>r((r=>{let[a]=r.useVariables(\"funcArg\"),i=`${r.printType(n)} ${a} = ${e}; `,o=r.emit(n,i,a),s=[...o.functionArguments||[],{name:e,num:t,type:n}];return s=Array.from(new Set(s)),o.functionArguments=s,o}));class m{constructor(e){this.idx=0,this.siblingContext=e,this.emittedVariables={},this.attributes=[],this.uniforms=[],this.varyings=[],this.errors=[],this.webGLRenderingContext=null,this.webGLProgram=null}initializeUniforms(){for(let e of this.uniforms)e.set()}isVariableEmitted(e){return!0===this.emittedVariables[e]}useVariables(...e){let t=this.idx++;return e.map((e=>`${e}${t}`))}gen(e){return void 0===e&&(e=0),\"number\"==typeof e?p(e)(this):e(this)}printType(e){return e===n.Float?\"float\":e===n.Vec2?\"vec2\":e===n.Vec3?\"vec3\":e===n.Vec4?\"vec4\":e===n.Mat2?\"mat2\":e===n.Mat3?\"mat3\":e===n.Mat4?\"mat4\":(console.log(\"type print type = \",n.Mat4,e),\"sampler2D\")}emitError(e){this.errors.push(e)}emit(e,t,r,...n){let a=new Set([r]);for(let{variables:e}of n)e&&e.forEach((e=>a.add(e)));let o=new Set([]);for(let{uniforms:e}of n)void 0!==e&&e.forEach((e=>o.add(e)));return{code:b(this,t,r,...n),uniforms:Array.from(o),variable:r,type:e,variables:Array.from(a),functions:l(...n),functionArguments:u(...n),attributes:i(...n)}}}class c extends m{constructor(e){super(),this.parentContext=e}}const p=e=>{let t=e.toString();return e-Math.floor(e)==0&&(t+=\".0\"),()=>({code:t,variable:t,variables:[],type:n.Float})},b=(e,t,r,...n)=>{let a=\"\";e.emittedVariables[r]=!0;for(let t of n)d(t)&&(a+=t.code,e.emittedVariables[t.variable]=!0);return a+\"\\n\"+t},d=e=>e.code!==e.variable,g=(e,t)=>(...n)=>r((r=>{let a=n.map((e=>r.gen(e))),[i]=r.useVariables(t+\"Val\"),o=(e=>{let t=e.map((e=>e.type));return Math.max(...t)})(a),s=`${r.printType(o)} ${i} = ${a.map((e=>e.variable)).join(e)};`;return r.emit(o,s,i,...a)})),y=(e,t=e,n,a)=>(...i)=>r((r=>{let o=i.map((e=>r.gen(e))),[s]=r.useVariables(`${t}Val`),l=void 0===a?o[0].type:a,u=r.printType(l),f=i.length>0&&n&&i.every((e=>\"number\"==typeof e))?`${u} ${s} = ${n(...i)};`:`${u} ${s} = ${e}(${o.map((e=>e.variable)).join(\",\")});`;return r.emit(l,f,s,...o)})),v=g(\"+\",\"add\"),A=g(\"-\",\"sub\"),h=g(\"*\",\"mult\"),E=g(\"/\",\"div\"),T=y(\"pow\",\"pow\",Math.pow),x=y(\"floor\",\"floor\",Math.floor),L=y(\"ceil\",\"ceil\",Math.ceil),$=y(\"sin\",\"sin\",Math.sin),R=y(\"cos\",\"cos\",Math.cos),_=y(\"tan\",\"tan\",Math.tan),S=y(\"smoothstep\"),I=y(\"step\"),N=y(\"mix\"),V=y(\"min\"),w=y(\"max\"),F=y(\"mod\"),C=y(\"sqrt\"),P=y(\"sign\"),M=y(\"normalize\"),G=y(\"exp\"),O=y(\"cross\"),j=y(\"exp2\"),B=y(\"length\",\"length\",void 0,n.Float),U=y(\"abs\",\"abs\"),D=y(\"dot\",\"dot\",void 0,n.Float),z=e=>r((t=>{let r=t.siblingContext?t.siblingContext.gen(e):t.gen(e),n=r.variable,a=r.type;if(!n){let e=r.attribute;if(e){let t=e.get();n=t.name,a=t.type}}let[i]=t.useVariables(\"v_varying_\"),o=r.code===n?\"\":r.code;return t.varyings.push({name:i,type:a,attributeName:n,code:o}),t.emit(r.type,\"\",i)})),Y=(e,t,r,n=[])=>{let a=e.code;a+=`\\n${r} = ${e.variable}; `;let i=\"\",o=new Set;if(e.uniforms)for(let r of e.uniforms)o.has(r.name)||(i+=`\\nuniform ${t.printType(r.type)} ${r.name};\\n`,o.add(r.name));let s=\"\";if(e.functions)for(let r of e.functions)s+=H(t,r);let l=\"\";for(let e of[...t.varyings,...n])l+=`varying ${t.printType(e.type)} ${e.name};\\n`;let u=\"\";if(t.attributes)for(let e of t.attributes)u+=`attribute ${t.printType(e.get().type)} ${e.get().name};\\n`;let f=\"\";for(let e of n)f+=`\\n    ${e.code}\\n    ${e.name} = ${e.attributeName};\\n`;let m=`\\nprecision mediump float;\\nuniform vec2 resolution;\\n${i}\\n${u}\\n${l}\\n\\n${s}\\n\\nvoid main() {\\n${a.split(\"\\n\").map((e=>\"    \"+e)).join(\"\\n\")}\\n${f}\\n}\\n`;return m},H=(e,t)=>{let r=`${e.printType(t.type)} ${t.variable}(`;return t.functionArguments&&(r+=t.functionArguments.sort(((e,t)=>e.num-t.num)).map((t=>`${e.printType(t.type)} ${t.name}`)).join(\",\")),r+=`) {\\n${t.code}\\n}\\n`,r},k=e=>()=>r((t=>{let[r]=t.useVariables(e+\"Val\"),a=n.Float,i=`${t.printType(n.Float)} ${r} = gl_FragCoord.${e};`;return t.emit(a,i,r)})),W=e=>t=>r((r=>{let[a]=r.useVariables(e+\"Val\"),i=r.gen(t),o=n.Float,s=`${r.printType(n.Float)} ${a} = ${i.variable}.${e};`;return r.emit(o,s,a,i)})),q=e=>{let t=e;return t.x=W(\"x\")(t),t.y=W(\"y\")(t),t.z=W(\"z\")(t),t.w=W(\"w\")(t),t},K=()=>q(r((e=>{let[t]=e.useVariables(\"uv\"),r=`${e.printType(n.Vec2)} ${t} = ((gl_FragCoord.xy-resolution)/resolution.y) ;\\n        `;return e.emit(n.Vec2,r,t)}))),Q=e=>(...t)=>q(r((r=>{let n=t.map((e=>r.gen(e))),[a]=r.useVariables(\"vectorVal\"),i=r.printType(e),o=`${i} ${a} = ${i} (${n.map((e=>e.variable)).join(\",\")}); `;return r.emit(e,o,a,...n)}))),X=Q(n.Vec2),J=Q(n.Vec3),Z=Q(n.Vec4),ee=k(\"x\"),te=k(\"y\"),re=(e,t,r=oe.TRIANGLE_STRIP)=>{if(!t){const e=a(n.Vec3,[1,1,-1,1,1,-1,-1,-1],2),r=q(e());t=Z(r.x,r.y,r.z,1)}let i=new m,o=new m(i),s=i.gen(t),l=o.gen(e);return{drawType:r,fragment:Y(l,o,\"gl_FragColor\"),vertex:Y(s,i,\"gl_Position\",o.varyings),fragmentContext:o,vertexContext:i}},ne=(e,t)=>{const r=t.getContext(\"webgl\");if(!r)return console.error(\"Unable to initialize WebGL. Your browser may not support it.\"),null;const n=r.getExtension(\"ANGLE_instanced_arrays\");if(!n)return console.error(\"Your browser does not support ANGLE_instanced_arrays\"),null;let a=0,i=0;for(let t of e){const e=ae(r,t.vertex,t.fragment);if(!e)return null;t.fragmentContext.webGLProgram=e,t.fragmentContext.webGLRenderingContext=r,t.vertexContext.webGLProgram=e,t.vertexContext.webGLRenderingContext=r,r.useProgram(e),t.fragmentContext.initializeUniforms();let a=0,i=0;t.buffers=[],t.binds=[];for(let o of t.vertexContext.attributes){let s=r.createBuffer();if(s){t.buffers.push(s);let l=o.get();if(l.buffer=s,t.binds.push((()=>{let t=r.getAttribLocation(e,l.name);if(r.bindBuffer(r.ARRAY_BUFFER,s),r.vertexAttribPointer(t,l.size,r.FLOAT,!1,0,0),r.enableVertexAttribArray(t),l.isInstance){let t=r.getAttribLocation(e,l.name);n.vertexAttribDivisorANGLE(t,1)}else{let t=r.getAttribLocation(e,l.name);n.vertexAttribDivisorANGLE(t,0)}})),l.isInstance){let e=l.data.length/l.size;i<e&&(i=e)}else{let e=l.data.length/l.size;a<e&&(a=e)}o.set(l.data)}}if(t.indices){let e=r.createBuffer();if(null===e)return null;t.indexBuffer=e,r.bindBuffer(r.ELEMENT_ARRAY_BUFFER,e),r.bufferData(r.ELEMENT_ARRAY_BUFFER,new Uint16Array(t.indices),r.STATIC_DRAW)}t.instanceCount=i,t.vertexCount=a,t.program=e}return r.enable(r.DEPTH_TEST),r.enable(r.BLEND),r.depthFunc(r.LEQUAL),r.blendFunc(r.SRC_ALPHA,r.ONE_MINUS_SRC_ALPHA),(o,s)=>{r.clearColor(0,0,0,1),r.clearDepth(1),r.clear(r.COLOR_BUFFER_BIT|r.DEPTH_BUFFER_BIT);let l=!1;o===a&&s===i||(l=!0);for(let u of e)if(u.program){if(r.useProgram(u.program),l){for(let t of e)if(t.program){let e=r.getUniformLocation(t.program,\"resolution\");r.uniform2f(e,o/2,s/2)}r.viewport(0,0,o,s),t.width=o,t.height=s,a=o,i=s}u.binds&&u.binds.forEach((e=>e()));const f=0;let m=se(r,u.drawType);u.instanceCount>0?n.drawArraysInstancedANGLE(m,0,u.vertexCount,u.instanceCount):u.indexBuffer&&u.indices?(r.bindBuffer(r.ELEMENT_ARRAY_BUFFER,u.indexBuffer),r.drawElements(m,u.indices.length,r.UNSIGNED_SHORT,0)):r.drawArrays(m,f,u.vertexCount)}}},ae=(e,t,r)=>{const n=ie(e,e.VERTEX_SHADER,t),a=ie(e,e.FRAGMENT_SHADER,r);if(!n||!a)return null;const i=e.createProgram();return i?(e.attachShader(i,n),e.attachShader(i,a),e.linkProgram(i),e.getProgramParameter(i,e.LINK_STATUS)?i:null):null},ie=(e,t,r)=>{const n=e.createShader(t);return n?(e.shaderSource(n,r),e.compileShader(n),e.getShaderParameter(n,e.COMPILE_STATUS)?n:(console.error(\"An error occurred compiling the shaders: \"+e.getShaderInfoLog(n)),e.deleteShader(n),null)):null};var oe;!function(e){e[e.TRIANGLES=0]=\"TRIANGLES\",e[e.TRIANGLE_STRIP=1]=\"TRIANGLE_STRIP\",e[e.TRIANGLE_FAN=2]=\"TRIANGLE_FAN\",e[e.LINE_LOOP=3]=\"LINE_LOOP\",e[e.LINE_STRIP=4]=\"LINE_STRIP\",e[e.LINES=5]=\"LINES\"}(oe||(oe={}));const se=(e,t)=>{switch(t){case oe.TRIANGLE_STRIP:return e.TRIANGLE_STRIP;case oe.TRIANGLE_FAN:return e.TRIANGLE_FAN;case oe.TRIANGLE_STRIP:return e.TRIANGLE_STRIP;case oe.LINES:return e.LINES;case oe.LINE_LOOP:return e.LINE_LOOP;case oe.LINE_STRIP:return e.LINE_STRIP;default:return e.TRIANGLES}},le=e=>(...t)=>r((r=>{let n=t.map((e=>r.gen(e))),[a]=r.useVariables(\"matVal\"),i=r.printType(e),o=`${i} ${a} = ${i} (${n.map((e=>e.variable)).join(\",\")}); `;return r.emit(e,o,a,...n)})),ue=le(n.Mat2),fe=le(n.Mat3),me=le(n.Mat4),ce=(e,t,r,n)=>{const a=E(1,_(E(e,2)));return me(E(a,t),0,0,0,0,a,0,0,0,0,E(v(n,r),A(r,n)),-1,0,0,E(h(2,h(n,r)),A(r,n)),0)},pe=(e,t,r)=>{let n=q(M(A(e,t))),a=q(M(O(r,n))),i=q(O(n,a));return me(a.x,i.x,n.x,0,a.y,i.y,n.y,0,a.z,i.z,n.z,0,h(-1,D(a,e)),h(-1,D(i,e)),h(-1,D(n,e)),1)},be=(e,t)=>{let n,a=[],i=t,o=\"_\"+Math.floor(1e5*Math.random()),s=()=>r((t=>{let r=t;for(;r.parentContext;)r=r.parentContext;let[i]=t.useVariables(\"uniform\"+o);n&&(i=n.name),n={name:i,type:e},a.push(r);let l=t.emit(e,\"\",i);return l.uniforms||(l.uniforms=[]),l.uniforms.push(n),t.uniforms.push(s),t.parentContext&&t.parentContext.uniforms.push(s),l}));return s.set=(e=i)=>{if(i=e,n)for(let t of a){let r=t.webGLRenderingContext,a=t.webGLProgram;if(r&&a){let t=r.getUniformLocation(a,n.name);r.uniform1f(t,e)}}},s},de=p;return t})()));;window.gl = gl;";
    }

    function getData() public view returns  (string memory) {
        return data;
    }
}