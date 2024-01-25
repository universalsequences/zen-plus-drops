
pragma solidity ^0.8.20;

contract ZenLibrary2 {
    string public data;

    constructor() {
        data = "Keys[_type];\\nids.push(_type);\\nkeys.push(type);\\n         if (!messages[type]) {\\n            messages[type] = {};\\n         }\\n         messages[type][subType] = body;\\n      }\\n      for (let type in messages) {\\n          for (let subType in messages[type]) {\\n             subType = parseFloat(subType);\\n             let msg = {type, subType, body: messages[type][subType]}; \\n             this.port.postMessage(msg);\\n          }\\n      }\\n      this.wasmModule.exports.empty_messages();\\n   }\\n\\n   queueMessage(type, subType, data) {\\n    // Get the subType map for the given type\\n    let subTypeMap = this.messageQueue.get(type);\\n    if (!subTypeMap) {\\n      subTypeMap = new Map();\\n      this.messageQueue.set(type, subTypeMap);\\n    }\\n\\n    // Add the message to the queue for the given type/subType\\n    subTypeMap.set(subType, data);\\n  }\\n\\n  checkMessages() {\\n    // Iterate over the message queue and send messages if the rate limit has elapsed\\n    for (const [type, subTypeMap] of this.messageQueue.entries()) {\\n      for (const [subType, message] of subTypeMap.entries()) {\\n          this.port.postMessage({type, subType, body: message});\\n      }\\n    }\\n  }\\n\\n  ${nt(\"   \",u)}\\n}\\n\\nregisterProcessor(\"${t}\", ${t}Processor)\\n`,wasm:m}},Ge=t=>{for(let e of t.histories)e.includes(\"*i\")||(t.code=We(t.code,e,\"\"));if(t.context.target===e.C){let e=(e=>{let t=e.context.memory.size,n=!0;e.functions.some((e=>e.code.includes(\"matrix4x4\")))||e.code.includes(\"matrix4x4\")||(n=!1),e.context.varKeyword;let a=`\\n${n?\"#include <wasm_simd128.h>\":\"\"}\\n#include <stdlib.h>\\n#include <emscripten.h>\\n#include <math.h>\\n#define BLOCK_SIZE 128 // The size of one block of samples\\n\\n#define MEM_SIZE ${t} // Define this based on your needs\\n#define SINE_TABLE_SIZE 1024\\n#define MAX_MESSAGES 10000\\n\\ndouble memory[MEM_SIZE]; // Your memory buffer\\ndouble  sineTable[SINE_TABLE_SIZE]; // Your memory buffer\\n\\nint elapsed = 0;\\n\\nstruct Message {\\n   int type;\\n   double subType;\\n   double body;\\n};\\n\\nint message_counter = 0;\\nstruct Message messages[MAX_MESSAGES];\\n\\nvoid new_message(int type, float subType, float body) {\\n   messages[message_counter].type = type;\\n   messages[message_counter].subType = subType;\\n   messages[message_counter].body = body;\\n   message_counter = (message_counter + 1);\\n   if (message_counter >= MAX_MESSAGES) {\\n     message_counter = 0;\\n   }\\n}\\n\\nEMSCRIPTEN_KEEPALIVE\\nint get_message_counter() {\\n  return message_counter;\\n}\\n\\n// Get a pointer to the messages array\\nstruct Message* EMSCRIPTEN_KEEPALIVE flush_messages() {\\n   return messages;\\n}\\n\\n\\n// Get a pointer to the messages array\\ndouble * EMSCRIPTEN_KEEPALIVE get_memory() {\\n        return memory;\\n    }\\n\\n    EMSCRIPTEN_KEEPALIVE\\n    void empty_messages() {\\n        //message_counter = 0;\\n    }\\n\\n    \\n    double random_double() {\\n        return rand() / (float)RAND_MAX;\\n    }\\n\\n${n?\"\\n    float matrix4x4SumResult[4];\\n\\n    float* matrix4x4Sum(int inputIdx, int matrixIdx, int size) {\\n       v128_t sum = wasm_f32x4_splat(0.0f); // initialize an SIMD vector with zeros\\n       int i=0;\\n       for (i=0; i < 4; i++) {\\n          v128_t weights = wasm_f32x4_splat(memory[inputIdx+i]); \\n          int idx = matrixIdx + i * size;\\n          v128_t row = wasm_v128_load(&memory[idx]);\\n          v128_t prod = wasm_f32x4_mul(row, weights);\\n          sum = wasm_f32x4_add(sum, prod);\\n       }\\n       wasm_v128_store(matrix4x4SumResult, sum); \\n       return matrix4x4SumResult;\\n    }\\n\":\"\"}\\n/*\\n*/\\n\\n    EMSCRIPTEN_KEEPALIVE\\n    void* my_malloc(size_t size) {\\n        return malloc(size);\\n    }\\n\\n    EMSCRIPTEN_KEEPALIVE\\n    void initSineTable() {\\n        for (int i = 0; i < SINE_TABLE_SIZE; i++) {\\n            sineTable[i] = sin((2 * M_PI * i) / SINE_TABLE_SIZE);\\n        }\\n    }\\n\\n/*\\n    void init(float * mem) {\\n        for (int i = 0; i < MEM_SIZE; i++) {\\n            memory[i] = mem[i];\\n        }\\n    }\\n*/\\n\\n    EMSCRIPTEN_KEEPALIVE\\n    void setMemorySlot(int idx, double val) {\\n        memory[idx] = val;\\n    }\\n\\n/*\\n    void setMemoryRegion(int idx, double* val, int size) {\\n        for (int i = 0; i < size; i++) {\\n            memory[idx + i] = val[i];\\n        }\\n    }\\n*/\\n\\n${it(e.functions,e.context.target,e.context.varKeyword)}\\n\\n    EMSCRIPTEN_KEEPALIVE\\n    void process(float * inputs, float * outputs) {\\n        for (int j = 0; j < BLOCK_SIZE; j++) {\\n      ${Ye(e)}\\n      ${Xe(e)}\\n      ${Ue(e)}\\n      ${nt(\"      \",e.code)}\\n      ${et(e)}\\n            elapsed++;\\n        }\\n    }\\n\\n    `;return n&&(a=We(a,\"double\",\"float\")),a})(t);return{code:`\\nprocess(inputs, outputs, parameters) {\\n    if (this.disposed || !this.ready) {\\n      return true;\\n    }\\n    const BLOCK_SIZE = 128;\\n    let inputChannel = inputs[0];\\n    let outputChannel = outputs[0];\\n\\n    if (this.messageCounter % 10 === 0) {\\n      this.flushWASMMessages();\\n    }\\n    this.messageCounter++;\\n\\n    this.scheduleEvents(128);\\n\\n    for (let i = 0; i < 1; i ++) {\\n      if (!this.wasmModule) {\\n         return true;\\n      } \\n      for (let j = 0; j < ${t.numberOfInputs}; j++) {\\n        const inputChannel = inputs[0][j];\\n        // Copy input samples to input buffer\\n        if (inputChannel) {\\n          this.input.set(inputChannel, j * 128);\\n        }\\n      } \\n\\n      // Process samples\\n      this.wasmModule.exports.process(this.inputPtr, this.outputPtr);\\n\\n      // Copy output buffer to output channel\\n      for (let j=0; j < ${t.numberOfOutputs}; j++) {\\n     \\n         let arr = this.output.slice(j*128, (j+1)*128);\\nif (j === 1) {\\n}\\n         outputs[0][j].set(arr, 0);\\n      }\\n    }\\n    return true;\\n}\\n`,wasm:e}}return{code:`\\n${it(t.functions,t.context.target,t.context.varKeyword)}\\nprocess(inputs, outputs) {\\n    if (this.disposed || !this.ready) {\\n      return true;\\n    }\\n  let memory = this.memory;\\n \\n\\n  // note: we need to go thru each output channel for each sample\\n  // instead of how we are doing it here... or else the histories\\n  // will get all messed up.\\n  // actually, really the whole channels concept should be removed...\\n  for (let j=0; j < outputs[0][0].length; j++) {\\n      let elapsed = this.elapsed++;\\n      this.messageCounter++;\\n\\n    if (this.messageCounter % 2000 === 0) {\\n      //this.checkMessages();\\n    }\\n      this.scheduleEvents();\\n      ${Ye(t)}\\n      ${Xe(t)}\\n      ${Ue(t)}\\n      ${nt(\"      \",t.code)}\\n      ${et(t)}\\n    }\\n  return true;\\n}\\n`,wasm:\"\"}},Ue=e=>Qe(e.context.varKeyword,e.histories,!0),Qe=(e,t,n=!0)=>{let a=\"\",i=[];for(let r of t)n&&r.includes(\"*i\")||(r=r.replace(\"let\",e)+\";\",i.includes(r)||a.includes(r)||(a+=nt(\"   \",r)),i.push(r));return a},Xe=e=>{let t=\"\";for(let n=0;n<e.numberOfOutputs;n++)t+=`${e.context.varKeyword} output${n} = 0;`;return t},Ye=t=>{let n=\"\";for(let a=0;a<t.numberOfInputs;a++)t.context.target===e.C?n+=`${t.context.varKeyword} in${a} = inputs[j + ${128*a}];\\n`:n+=`${t.context.varKeyword} in${a} = inputs[0][${a}]  ? inputs[0][${a}][j] : 0;\\n`;return n},et=t=>{let n=\"\";for(let a=0;a<t.numberOfOutputs;a++)t.context.target===e.C?n+=`\\noutputs[j + ${128*a}] = output${a};\\n`:n+=`\\n            outputs[0][${a}][j] = output${a};\\n            `;return n},tt=e=>`\\n            this.memory = new Float64Array(${e.context.memory.size});\\n            `,nt=(e,t)=>t.split(\"\\n\").map((t=>e+t)).join(\"\\n\"),at=(e,t)=>{for(let n of e.memory.blocksInUse)void 0!==n.initData&&(void 0===n._idx?n.idx:n._idx,t.port.postMessage({type:\"init-memory\",body:{idx:void 0===n._idx?n.idx:n._idx,data:n.initData}}))},it=(t,n,a)=>{let i=\"\";for(let r of t){let t=r.name,s=r.code,o=rt(r.functionArguments);o.sort(((e,t)=>e.num-t.num));let l=o.map((t=>(n===e.C?a+\" \":\"\")+t.name)).join(\",\"),u=r.histories,m=(e.C,n===e.C?\"\":\"let memory = this.memory;\"),$=Qe(\"let\",u,!1);for(let e of u)s=We(s,e,\"\");let d=`\\n${n===e.C?\"\":\"let elapsed = this.elapsed\"}\\n${m}\\n${$}\\n${s}\\nreturn ${r.variable};\\n    `,h=n===e.C?a+\"* \":\"\",c=n===e.C?\"int \":\"\";i+=`\\n ${n===e.C?`${a} ${t}Array[16];`:`${t}Array = new Float32Array(16)`}\\n\\n${h} ${t}(${c} invocation, ${l}) {\\n${nt(\"    \",d)}\\n}\\n            `}return i},rt=e=>{let t=[];for(let n of e)t.some((e=>e.num===n.num))||t.push(n);return t},st=(e,t)=>o((n=>{let[a,i]=n.useVariables(\"i\",\"sum\"),r=\"number\"==typeof e.min&&\"number\"==typeof e.max?new ue(a,e,n):n,s=n.gen(e.min),o=n.gen(e.max),l=lt(a),u=t(l)(r),m=Array.from(new Set(u.histories));m=m.map((e=>We(e,\"let\",n.varKeyword)+\";\"));let $=Array.from(new Set(u.outerHistories));$=$.map((e=>We(e,\"let\",n.varKeyword)+\";\"));let d=`\\n${nt(\"    \",$.join(\"\"))}\\n${n.varKeyword} ${i} = 0;\\nfor (${n.intKeyword} ${a}=${s.variable}; ${a} < ${o.variable}; ${a}++ ) {\\n${nt(\"    \",m.join(\"\\n\"))}\\n${nt(\"    \",u.code)}\\n    ${i} += ${u.variable};\\n}\\n`;return n.emit(d,i)})),ot=(e,t,n)=>o((a=>{let[i]=a.useVariables(\"sum\"),r=\"number\"==typeof e.min&&\"number\"==typeof e.max?new ue(n,e,a):a;console.log(\"creating loop context=\",r);let s=a.gen(e.min),o=a.gen(e.max),l=t(r),u=Array.from(new Set(l.histories));u=u.map((e=>We(e,\"let\",a.varKeyword)+\";\"));let m=Array.from(new Set(l.outerHistories)).filter((e=>!a.historiesEmitted.includes(e)));a.historiesEmitted=[...a.historiesEmitted,...m],m=m.map((e=>We(e,\"let\",a.varKeyword)+\";\"));let $=`\\n${nt(\"    \",m.join(\"\"))}\\n${a.varKeyword} ${i} = 0;\\nfor (${a.intKeyword} ${n}=${s.variable}; ${n} < ${o.variable}; ${n}++ ) {\\n${nt(\"    \",u.join(\"\"))}\\n${nt(\"    \",l.code)}\\n    ${i} += ${l.variable};\\n}\\n`;return a.emit($,i)})),lt=e=>t=>{let[n]=t.useVariables(\"loopIdx\"),a=`${t.context?t.context.intKeyword:t.intKeyword} ${n} = ${e};`,i=t.emit(a,n);return i.isLoopDependent=!0,i},ut=(t,n,a)=>o((i=>{let r=i.gen(a),s=i.gen(n),[o]=i.useVariables(\"message\"),l=\"\";return i.target===e.C?l+=`\\nnew_message(@beginMessage${t}@endMessage, ${s.variable}, ${r.variable});\\n`:l+=`\\nif (this.messageCounter % 1000 === 0) {\\nthis.port.postMessage({type: @beginMessage${t}@endMessage, subType: ${s.variable}, body: ${r.variable}});\\n/*\\n    let subTypeMap = this.messageQueue[@beginMessage${t}@endMessage];\\n    if (!subTypeMap) {\\nconsole.log(\"creating new array\");\\n      subTypeMap = new Float32Array(8);\\n      this.messageQueue[@beginMessage${t}@endMessage] = subTypeMap;\\n    }\\n\\n    // Add the message to the queue for the given type/subType\\n    subTypeMap[${s.variable}]= ${r.variable};\\n*/\\n}\\n`,l+=`\\n${i.varKeyword} ${o} = ${r.variable};\\n\\n`,i.emit(l,o,s,r)})),mt=(e,t,n)=>o((a=>{let i=a.gen(e),r=a.gen(t),s=a.gen(n),[o]=a.useVariables(\"switch\"),l=`${a.varKeyword} ${o} = ${i.variable} ? ${r.variable} : ${s.variable};`;return a.emit(l,o,i,r,s)})),$t=(e,t,n)=>a=>{let i=a.gen(e),r=a.gen(t),s=a.gen(n),[o]=a.useVariables(\"switch\"),l=`let ${o} = ${i.variable} ? ${r.variable} : ${s.variable}`;return a.emit(l,o,i,s)},dt=(e,t,n)=>a=>{let i=a.gen(e),r=a.gen(t),s=a.gen(n),[o]=a.useVariables(\"switch\"),l=`let ${o} = ${i.variable} ? ${r.variable} : ${s.code}`;return a.emit(l,o,i,r)},ht=m(\"Math.random\",\"random\"),ct=(t,n,a,i,r,s=1)=>o((o=>{let l=o.gen(t),u=o.gen(n),m=o.gen(i),$=o.gen(a),d=o.gen(r),h=o.gen(s),c=o.idx++,p=`scaleVal${c}`,b=`range1${c}`,y=`range2${c}`,f=`normVal${c}`,g=\"number\"==typeof n&&\"number\"==typeof a?a-n:`${$.variable} - ${u.variable}`,v=\"number\"==typeof i&&\"number\"==typeof r?r-i:`${d.variable} - ${m.variable}`,x=o.target===e.C?\"pow\":\"Math.pow\",w=`${o.varKeyword} ${b} = ${g};\\n${o.varKeyword} ${y} = ${v};\\n${o.varKeyword} ${f} = ${b} == 0 ? 0 :\\n    (${l.variable} - ${u.variable}) / ${b};\\n${o.varKeyword} ${p} = ${m.variable} + ${y} * ${x}(${f}, ${h.variable});`;return o.emit(w,p,l,u,$,m,d,h)})),pt=(...e)=>t=>{let n=\"\",a=\"\",i=[],r=[],s=[],o=[],l=[],u=0;for(let m of e){if((new Date).getTime(),\"function\"!=typeof m)continue;let e=m(t);l=[...l,...e.params],n+=\" \"+e.code+\";\",a=e.variable,t.emittedVariables[a]=!0,e.histories&&(i=[...i,...e.histories]),e.outerHistories&&(r=[...r,...e.outerHistories]),e.functions&&(s=[...s,...e.functions]),e.functionArguments&&(o=[...o,...e.functionArguments]),(new Date).getTime(),e.outputs>u&&(u=e.outputs)}return{functions:s,functionArguments:o,outputs:u,params:l,code:n,variable:a,histories:i,outerHistories:r}};class bt{constructor(e,t,n){this.connections=[],this.isEntryPoint=n,this.material=e,console.log(\"component initialized with material = \",this.material),this.web=t,this.neighbors=je(t.size*t.maxNeighbors,1,t.neighbors,!0,\"none\"),this.coeffs=t.data,this.dampening=t.dampeningData,this.nt2=B(P(2,-8),P(2,-13),e.release),this.u=je(t.size,3,void 0,!0,\"none\"),this.currentChannel=accum(1,0,{min:0,max:2,exclusive:!1}),this.prevChannel=c(this.currentChannel,1),this.u_center=Pe(this.u,0,this.prevChannel),this.tension=B(P(2,-12),P(2,-5),.0999151),this.p0=B(11044095e-20,.01,e.pitch),this.p_eff=N(.47,$(this.p0,P(b(this.u_center,this.tension,1),2)))}get size(){return this.web.size}gen(e){return this.isEntryPoint&&(this.excitementEnergy=e),pt(this.currentChannel,this.prevChannel,e,this.nt2,this.u_center,this.tension,this.p0,this.material.couplingCoefficient,this.p_eff,b(y(200,this.size),st({min:0,max:this.size},(t=>this.nodeDisplacement(e,t)))))}nodeDisplacement(e,t){let n=Pe(this.u,t,this.prevChannel),a=this.calculateNeighborsEnergy(t,n,e),i=b(e,this.lerpExcitementEnergy(t,this.material.x,this.material.y)),r=Pe(this.u,t,c(this.currentChannel,2)),s=B(P(2,-8),P(2,-13),b(Pe(this.dampening,t,0),this.material.release)),o=y($(b(2,n),b(this.p_eff,$(a,b(1,i),b(-4,n))),b(-1,c(1,s),r)),$(1,s));return pt(Le(this.u,t,this.currentChannel,y(L(b(.6366197723675814,o)),.6366197723675814)),o)}lerpExcitementEnergy(e,t,n){let a=b(e,2),i=Pe(this.web.pointsData,a,0),r=Pe(this.web.pointsData,$(a,1),0),s=R($(P(c(i,t),2),P(c(r,n),2))),o=Z(c(1,y(s,80)),0,1);return D(y((e=>b(-1,e))(P(s,2)),b(2,P(y(80,2),2)))),o}calculateNeighborsEnergy(e,t,n){let a=N(20,this.material.noise),i=b(ct(ht(),0,1,-1,1),a);this.connections[0]&&this.connections[0].component.isEntryPoint&&(n=this.connections[0].component.excitementEnergy);let r=b(.5,$(b(B(P(n,.5),t,1),i),this.sumNeighbors(e,this.prevChannel,this.web.maxNeighbors,this.u,this.neighbors,this.coeffs)));for(let n of this.connections){let{component:a,neighbors:i}=n,s=Pe(i,e,0),o=K(s,-1),l=Pe(a.u,s,a.prevChannel),u=c(l,t),m=mt(o,b(u,this.material.couplingCoefficient),0);r=$(r,m)}return r}sumNeighbors(e,t=this.prevChannel,n,a=this.u,i=this.neighbors,r=this.coeffs){return st({min:0,max:n+1},(s=>{let o=Pe(i,$(b(n,e),s),0),l=Pe(r,o,e);return pt(mt(K(o,-1),b(mt(_(l,-1),b(-1,Pe(a,e,t)),Pe(a,o,t)),l),0))}))}bidirectionalConnect(e){let t,n;if(e.size<this.size){let[a,i]=yt(e,this);t=a,n=i}else{let[a,i]=yt(this,e);t=i,n=a}let a=je(t.length,1,t,!0,\"none\"),i=je(n.length,1,n,!0,\"none\");this.connections.push({component:e,neighbors:i}),e.connections.push({component:this,neighbors:a})}}const yt=(e,t)=>{let n=new Float32Array(e.size);for(let a=0;a<e.size;a++)n[a]=t.size-1-a;let a=new Float32Array(t.size),i=t.size-e.size;for(let e=0;e<t.size;e++)a[e]=e<i?-1:t.size-e-1;return[n,a]},ft=(e,t=\"hello\")=>{let n=ie(e,{inline:!1,name:t}),a=n();return a.set=(e,t)=>{n.value(e,t)},a},gt=t=>o((n=>{let[a]=n.useVariables(\"t60Val\"),i=n.gen(t),r=n.target===e.C?u[\"Math.exp\"]:\"Math.exp\",s=`\\n${n.varKeyword} ${a} = ${r}(-6.907755278921 / ${i.variable});\\n`;return n.emit(s,a,i)})),vt=(e=44100)=>{let t=ie(),n=t(b(t(),gt(e)));return n.trigger=()=>{t.value(1)},n},xt=(e,t=44100)=>{let n=ie();return n(B(e,n(),gt(t)))},wt=(e,t=.5)=>o((n=>mt(f(e,t),ct(e,0,t,0,1),ct(e,t,1,1,0))(n))),Mt=e=>ct(z(b(Math.PI,e)),1,-1,0,1),_t=e=>o((t=>{let n=t.gen(e),[a]=t.useVariables(\"ms\"),i=`${t.varKeyword} ${a} = 1000.0*${n.variable}/${t.sampleRate};`;return t.emit(i,a,n)})),Kt=e=>o((t=>{let n=t.gen(e),[a]=t.useVariables(\"samps\"),i=`${t.varKeyword} ${a} = (${n.variable}/1000)*${t.sampleRate};`;return t.emit(i,a,n)})),Ct=e=>{let t=ie();return c(e,t(B(e,t(),.999)))},Et=()=>o((e=>{let[t]=e.useVariables(\"elapsed\"),n=`${e.varKeyword} ${t} = elapsed;`;return e.emit(n,t)})),St=t=>o((n=>{let a=n.gen(t),[i]=n.useVariables(\"fixed\"),r=n.target===e.C?\"isnan\":\"isNaN\",s=`${n.varKeyword} ${i} = ${r}(${a.variable}) ? 0.0 : ${a.variable};`;return n.emit(s,i,a)}));return n})()));;window.ZEN_LIB = zen; Object.keys(ZEN_LIB).forEach(key => window[key] = ZEN_LIB[key]);";
    }

    function getData() public view returns  (string memory) {
        return data;
    }
}