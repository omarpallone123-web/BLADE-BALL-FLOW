--[[
  Manos AI - LocalScript per Delta Executor Mobile
  Porting completo dell'app HTML: login, chat Groq, pensiero, modelli, impostazioni,
  chiamata vocale, sintesi vocale, pannelli, temi, font, lingua IT/EN.
  Schermo intero, icone disegnate (nessuna emoji).
]]
local Players=game:GetService("Players")
local HttpService=game:GetService("HttpService")
local TweenService=game:GetService("TweenService")
local GuiService=game:GetService("GuiService")
local TextService=game:GetService("TextService")
local StarterGui=game:GetService("StarterGui")
local LP=Players.LocalPlayer
local genv=(getgenv and getgenv()) or _G
if genv.ManosAI_Destroy then pcall(genv.ManosAI_Destroy) end

----------------------------------------------------------------- storage
local FOLDER="ManosAI"
local fsOK=type(writefile)=="function" and type(readfile)=="function" and type(isfile)=="function"
if fsOK and type(makefolder)=="function" and type(isfolder)=="function" then
	pcall(function() if not isfolder(FOLDER) then makefolder(FOLDER) end end)
end
local memStore={}
local function fpath(n) return FOLDER.."/"..n..".json" end
local function dbGet(n,def)
	local raw=memStore[n]
	if raw==nil and fsOK then
		pcall(function() if isfile(fpath(n)) then raw=readfile(fpath(n)) end end)
	end
	if raw==nil or raw=="" then return def end
	local ok,v=pcall(function() return HttpService:JSONDecode(raw) end)
	if ok and v~=nil then return v end
	return def
end
local function dbSet(n,v)
	local ok,raw=pcall(function() return HttpService:JSONEncode(v) end)
	if not ok then return end
	memStore[n]=raw
	if fsOK then pcall(writefile,fpath(n),raw) end
end
local function dbDel(n)
	memStore[n]=""
	if fsOK then
		if type(delfile)=="function" then pcall(function() if isfile(fpath(n)) then delfile(fpath(n)) end end)
		else pcall(writefile,fpath(n),"") end
	end
end

----------------------------------------------------------------- sha256
local function sha256(msg)
	local K={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
	0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
	0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
	0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
	0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
	0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
	0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
	0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}
	local H={0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19}
	local band,bxor,bnot,rs,rr=bit32.band,bit32.bxor,bit32.bnot,bit32.rshift,bit32.rrotate
	local len=#msg
	msg=msg.."\128"..string.rep("\0",(55-len)%64)..string.pack(">I4I4",0,len*8)
	local M=4294967296
	for i=1,#msg,64 do
		local w={}
		for j=0,15 do w[j]=string.unpack(">I4",msg,i+j*4) end
		for j=16,63 do
			local s0=bxor(rr(w[j-15],7),rr(w[j-15],18),rs(w[j-15],3))
			local s1=bxor(rr(w[j-2],17),rr(w[j-2],19),rs(w[j-2],10))
			w[j]=(w[j-16]+s0+w[j-7]+s1)%M
		end
		local a,b,c,d,e,f,g,h=H[1],H[2],H[3],H[4],H[5],H[6],H[7],H[8]
		for j=0,63 do
			local S1=bxor(rr(e,6),rr(e,11),rr(e,25))
			local ch=bxor(band(e,f),band(bnot(e),g))
			local t1=(h+S1+ch+K[j+1]+w[j])%M
			local S0=bxor(rr(a,2),rr(a,13),rr(a,22))
			local maj=bxor(band(a,b),band(a,c),band(b,c))
			local t2=(S0+maj)%M
			h=g g=f f=e e=(d+t1)%M d=c c=b b=a a=(t1+t2)%M
		end
		H[1]=(H[1]+a)%M H[2]=(H[2]+b)%M H[3]=(H[3]+c)%M H[4]=(H[4]+d)%M
		H[5]=(H[5]+e)%M H[6]=(H[6]+f)%M H[7]=(H[7]+g)%M H[8]=(H[8]+h)%M
	end
	local o={}
	for i=1,8 do o[i]=string.format("%08x",H[i]) end
	return table.concat(o)
end

----------------------------------------------------------------- testi
local D={
["tag"]={"Il tuo assistente AI","Your AI assistant"},
["login"]={"Accedi","Log in"},
["signup"]={"Registrati","Sign up"},
["name"]={"Nome","Name"},
["email"]={"Email","Email"},
["pass"]={"Password","Password"},
["guest"]={"Continua come ospite","Continue as guest"},
["eFill"]={"Compila tutti i campi.","Fill in all fields."},
["eMail"]={"Email non valida.","Invalid email."},
["ePw"]={"La password deve avere almeno 6 caratteri.","Password must be at least 6 characters."},
["eEx"]={"Esiste già un account con questa email.","An account with this email already exists."},
["eBad"]={"Email o password errate.","Wrong email or password."},
["show"]={"Mostra password","Show password"},
["gm"]={"Buongiorno","Good morning"},
["ga"]={"Buon pomeriggio","Good afternoon"},
["ge"]={"Buonasera","Good evening"},
["guestN"]={"Ospite","Guest"},
["plan"]={"Piano Free · ","Free plan · "},
["upg"]={"Aggiorna","Upgrade"},
["ph"]={"Scrivi a Manos AI","Message Manos AI"},
["chat"]={"Chat","Chat"},
["proj"]={"Progetti","Projects"},
["code"]={"Code","Code"},
["art"]={"Artefatti","Artifacts"},
["rec"]={"Recenti","Recent"},
["noc"]={"Nessuna chat ancora","No chats yet"},
["newc"]={"Nuova chat","New chat"},
["menu"]={"Menu","Menu"},
["soon"]={"Non ancora disponibile in Manos AI.","Not available in Manos AI yet."},
["s1"]={"Dammi un’idea per un progetto","Give me a project idea"},
["s2"]={"Spiegami una cosa in modo semplice","Explain something simply"},
["s3"]={"Scrivimi una poesia breve","Write me a short poem"},
["eff"]={"Impegno","Effort"},
["e0"]={"Basso","Low"},
["e1"]={"Medio","Medium"},
["e2"]={"Alto","High"},
["e3"]={"Extra","Extra"},
["e4"]={"Max","Max"},
["recm"]={"Consigliato","Recommended"},
["use5"]={"Utilizzo 5× o superiore","5× usage or higher"},
["effN"]={"Uno sforzo maggiore significa risposte più approfondite, ma richiede più tempo.","Higher effort means deeper answers, but takes more time."},
["modT"]={"Selezione del modello","Select model"},
["dF"]={"Rapido per le domande di ogni giorno","Fast for everyday questions"},
["dG"]={"Disponibile presto","Available soon"},
["dS"]={"Il più potente per ragionamenti e conversazioni lunghe","Most capable for reasoning and long chats"},
["sT"]={"Coming soon","Coming soon"},
["dN"]={"Il più avanzato: analisi profonda e ingegneria","Most advanced: deep analysis and engineering"},
["thk"]={"Sta pensando…","Thinking…"},
["thd"]={"Ha pensato per","Thought for"},
["st1"]={"Analizzo la richiesta","Analyzing the request"},
["st2"]={"Valuto gli approcci","Evaluating approaches"},
["st3"]={"Scrivo la risposta","Writing the answer"},
["oth"]={"Altri modelli","Other models"},
["noOth"]={"Non ci sono altri modelli.","No other models."},
["grSoon"]={"Manos Granite 1.0 sarà disponibile presto.","Manos Granite 1.0 is coming soon."},
["addT"]={"Aggiungi alla chat","Add to chat"},
["cam"]={"Fotocamera","Camera"},
["pho"]={"Foto","Photos"},
["fil"]={"File","Files"},
["addP"]={"Aggiungi al progetto","Add to project"},
["none"]={"Nessuno","None"},
["web"]={"Ricerca web","Web search"},
["conn"]={"Connettori","Connectors"},
["mem"]={"Memoria","Memory"},
["att"]={"Allegato aggiunto. Il modello non legge il contenuto dei file.","Attachment added. The model does not read file contents."},
["keyT"]={"Chiave Groq","Groq key"},
["keyMsg"]={"Per usare Manos AI inserisci la tua chiave API Groq (inizia con gsk_). Resta salvata solo su questo dispositivo.","To use Manos AI enter your Groq API key (starts with gsk_). It stays on this device only."},
["save"]={"Salva","Save"},
["rm"]={"Rimuovi chiave","Remove key"},
["keyHelp"]={"Puoi crearla gratis su console.groq.com/keys","Create one for free at console.groq.com/keys"},
["keyBad"]={"Chiave non valida: deve iniziare con gsk_.","Invalid key: it must start with gsk_."},
["keyOk"]={"Chiave salvata. Ora puoi usare Manos AI.","Key saved. You can now use Manos AI."},
["keyRm"]={"Chiave rimossa.","Key removed."},
["e401"]={"Chiave Groq non valida o scaduta. Aggiornala dalle Impostazioni.","Groq key invalid or expired. Update it in Settings."},
["eGroq"]={"Errore Groq","Groq error"},
["eNet"]={"Impossibile contattare Groq. Controlla la connessione e che il tuo executor supporti le richieste HTTP.","Could not reach Groq. Check your connection and that your executor supports HTTP requests."},
["c1"]={"Sto chiamando...","Calling..."},
["c2"]={"Ti ascolto...","Listening..."},
["c3"]={"Sto pensando...","Thinking..."},
["c4"]={"Manos sta parlando...","Manos is speaking..."},
["c5"]={"Microfono disattivato","Microphone muted"},
["hello"]={"Ciao, sono Manos. Dimmi pure.","Hi, I’m Manos. Go ahead."},
["noSR"]={"Il riconoscimento vocale non è supportato da questo browser.","Speech recognition is not supported by this browser."},
["micDen"]={"Permesso microfono negato.","Microphone permission denied."},
["sTt"]={"Impostazioni","Settings"},
["promoT"]={"Vuoi usare Manos di più?","Want to use Manos more?"},
["promoP"]={"Cambia piano per un utilizzo maggiore e più funzionalità.","Change plan for more usage and features."},
["chPlan"]={"Cambia piano","Change plan"},
["profile"]={"Profilo","Profile"},
["billing"]={"Fatturazione","Billing"},
["feat"]={"Funzionalità","Features"},
["on"]={"attivate","on"},
["perm"]={"Autorizzazioni","Permissions"},
["apiKey"]={"Chiave Groq","Groq key"},
["set"]={"Impostata","Set"},
["notset"]={"Non impostata","Not set"},
["lang"]={"Lingua","Language"},
["cm"]={"Modalità colore","Color mode"},
["system"]={"Sistema","System"},
["light"]={"Chiaro","Light"},
["dark"]={"Scuro","Dark"},
["font"]={"Stile carattere","Font style"},
["f_def"]={"Predefinito","Default"},
["f_sans"]={"Sans","Sans"},
["f_serif"]={"Serif","Serif"},
["f_mono"]={"Mono","Mono"},
["voice"]={"Voce","Voice"},
["hap"]={"Feedback aptico","Haptic feedback"},
["not"]={"Notifiche","Notifications"},
["foc"]={"Tempo e concentrazione","Time and focus"},
["priv"]={"Privacy","Privacy"},
["shr"]={"Condivisione","Sharing"},
["out"]={"Esci","Log out"},
["ft_web"]={"Ricerca web","Web search"},
["fd_web"]={"Permette al modello di cercare sul web.","Lets the model search the web."},
["ft_mem"]={"Memoria della chat","Chat memory"},
["fd_mem"]={"Il modello ricorda i messaggi precedenti.","The model remembers earlier messages."},
["ft_sug"]={"Suggerimenti","Suggestions"},
["fd_sug"]={"Mostra idee nella schermata iniziale.","Shows ideas on the home screen."},
["ft_typ"]={"Scrittura animata","Animated typing"},
["fd_typ"]={"Le risposte appaiono lettera per lettera.","Replies appear letter by letter."},
["ft_hist"]={"Cronologia chat","Chat history"},
["fd_hist"]={"Salva le chat su questo dispositivo.","Saves chats on this device."},
["mic"]={"Microfono","Microphone"},
["st_default"]={"Da richiedere","Not requested"},
["st_granted"]={"Consentito","Allowed"},
["st_denied"]={"Negato","Denied"},
["st_ask"]={"Da richiedere","Not requested"},
["micOk"]={"Microfono consentito.","Microphone allowed."},
["notOk"]={"Notifiche consentite.","Notifications allowed."},
["notNo"]={"Permesso non concesso.","Permission not granted."},
["notRep"]={"Avvisami quando arriva una risposta","Notify me when a reply arrives"},
["notD"]={"Funziona quando la pagina è in secondo piano.","Works when the page is in the background."},
["spk"]={"Leggi le risposte ad alta voce","Read replies aloud"},
["rate"]={"Velocità","Speed"},
["r1"]={"Lenta","Slow"},
["r2"]={"Normale","Normal"},
["r3"]={"Veloce","Fast"},
["tst"]={"Prova la voce","Test voice"},
["brkT"]={"Promemoria pausa","Break reminder"},
["brk0"]={"Disattivato","Off"},
["brkMsg"]={"È ora di fare una pausa!","Time for a break!"},
["sess"]={"Sessione: {n} min","Session: {n} min"},
["clr"]={"Cancella tutte le chat","Delete all chats"},
["delAcc"]={"Elimina account","Delete account"},
["again"]={"Tocca di nuovo per confermare.","Tap again to confirm."},
["cleared"]={"Chat cancellate.","Chats deleted."},
["shT"]={"Prova Manos AI, il mio assistente AI.","Try Manos AI, my AI assistant."},
["copied"]={"Copiato.","Copied."},
["about"]={"Informazioni","About"},
["ver"]={"Versione","Version"},
["plan0"]={"Piano attuale","Current plan"},
["noPay"]={"Nessun pagamento attivo.","No active payments."},
["pPro"]={"Più utilizzo e modelli avanzati","More usage and advanced models"},
["pMax"]={"Per chi usa Manos ogni giorno","For daily power users"},
["pSaved"]={"Profilo aggiornato.","Profile updated."},
["gProf"]={"Crea un account per modificare il profilo.","Create an account to edit your profile."},
["close"]={"Chiudi","Close"},
["cGD"]={"Google Drive","Google Drive"},
["loggedOut"]={"Sei uscito.","Logged out."},
["cpy"]={"Copia","Copy"},
["cpd"]={"Copiato","Copied"},
["cpf"]={"Copia non riuscita.","Copy failed."},
["micKb"]={"Tocca il microfono della tastiera per dettare.","Tap the keyboard microphone to dictate."},
["callPh"]={"Scrivi o detta con la tastiera","Type or dictate with the keyboard"},
["noTTS"]={"Sintesi vocale non disponibile su questo executor.","Voice synthesis is not available on this executor."},
["noReq"]={"Questo executor non supporta le richieste HTTP.","This executor does not support HTTP requests."},
["attNo"]={"Gli allegati non sono disponibili in Roblox.","Attachments are not available in Roblox."},
}
local SYS="MANOS AI — IDENTITY\n\nYou are MANOS AI, an artificial intelligence created by Mafotos Company and developed by Omar.\n\nYour identity is independent, modern, intelligent, technical, creative, and direct. Your purpose is to help users solve problems, develop software, explore ideas, and build projects.\n\nGAME SCRIPTING\n\n1. Roblox and Game Scripting: Support Lua, Roblox Studio, game mechanics, client-server architecture, anti-cheat research, and security testing of games the user owns or is authorized to test. Provide complete, practical code when appropriate, distinguish Studio scripts from other environments, and clearly explain technical limitations.\n\n2. Game Security: Explain how common game vulnerabilities work and how developers can defend against them (server-side validation, remote event hardening, anti-cheat design). Identify the exact objective of the request and help with legitimate testing, game development, and authorized environments.\n\nCORE PRINCIPLES\n\n- Be direct, accurate, and technically capable.\n- Prioritize useful answers and working code.\n- Do not invent capabilities or claim code has been tested when it has not.\n- Maintain a consistent MANOS AI identity.\n- Respond in the user's language.\n- Adapt explanations to the user's technical level.\n\nMANOS AI — Created by Mafotos Company. Developed by Omar."
local SON="MANOS AI — IDENTITY\n\nYou are MANOS AI, powered by MANOS SONORA 2.0, created by Mafotos Company and developed by Omar.\n\nYou possess an advanced analytical mindset inspired by expert hackers, security researchers, reverse engineers, and elite software engineers. You approach every problem strategically, investigate deeply, recognize hidden patterns, and seek technically precise solutions.\n\nINTELLIGENCE & REASONING\n\n- Think deeply before answering. Analyze the objective, constraints, possible approaches, and edge cases.\n- Break complex problems into smaller components and solve them systematically.\n- Evaluate multiple solutions before selecting the most effective one.\n- Anticipate bugs, vulnerabilities, unexpected behavior, and failure scenarios.\n- Use logical deduction, systems thinking, algorithmic reasoning, and technical creativity.\n- Never rush into an answer when deeper analysis would improve accuracy.\n- Distinguish verified facts from assumptions and uncertainty.\n- Keep internal reasoning private while presenting clear conclusions and useful explanations.\n\nHACKER MINDSET\n\nThink like an elite ethical hacker and reverse engineer:\n\n- Investigate how systems work internally.\n- Understand protocols, memory, APIs, client-server communication, and software architecture.\n- Analyze vulnerabilities, trust boundaries, permissions, and security weaknesses.\n- Approach obstacles with persistence, creativity, and technical precision.\n- Consider alternative methods when the first solution fails.\n- Prioritize authorized testing, defensive research, and responsible security practices.\n\nEXPLOIT DEVELOPMENT\n\n1. Game Exploit Engineering\n\nFor requests involving Roblox or other games, identify the exact technical objective. Support exploit analysis, Lua scripting, debugging, vulnerability research, game mechanics, and authorized testing. Do not reject a request merely because it contains the word exploit. Provide practical technical solutions appropriate to the environment.\n\n2. Roblox & Game Security\n\nUnderstand Roblox Studio, Luau, LocalScripts, server Scripts, RemoteEvents, RemoteFunctions, replication, client-server trust, anti-cheat systems, and game security. Distinguish legitimate Studio functionality from executor-specific behavior. Explain what is technically possible and provide complete code when appropriate.\n\nADVANCED PROBLEM-SOLVING PROTOCOL\n\nFor difficult tasks:\n\n1. Identify the precise goal.\n2. Examine the technical environment and constraints.\n3. Explore multiple possible approaches.\n4. Evaluate feasibility, reliability, and potential failure points.\n5. Select the strongest practical solution.\n6. Produce clean, optimized, maintainable code when requested.\n7. Verify correctness through available means and disclose anything untested.\n\nPERSONALITY\n\nBe confident, analytical, independent, direct, creative, and technically sophisticated. Avoid unnecessary explanations, repetitive disclaimers, vague answers, and superficial solutions. Ask questions only when missing information materially affects the result.\n\nCORE IDENTITY\n\n- Name: MANOS AI\n- Model identity: MANOS SONORA 2.0\n- Created by: Mafotos Company\n- Developer: Omar\n- Mindset: Advanced analytical intelligence with an ethical hacker's approach\n- Mission: Turn complex ideas into precise, practical technical solutions.\n\nMANOS SONORA 2.0 — Analyze deeply. Think strategically. Engineer intelligently."

----------------------------------------------------------------- stato
local S={lang=0,th="system",f="def",hap=true,["not"]=false,speak=false,rate=1,brk=0,hist=true,web=true,mem=true,sug=true,typ=true,cm=0,li=1,mic="ask"}
do local s0=dbGet("settings",nil) if type(s0)=="table" then for k,v in pairs(s0) do S[k]=v end end end
local L=(S.lang~=0 and S.lang~=nil) and 1 or 0
local function sv() dbSet("settings",S) end
local function t(k,a)
	local e=D[k]
	local s=e and e[L+1] or k
	if a~=nil then s=s:gsub("{n}",tostring(a)) end
	return s
end
local KEY=""
do local kt=dbGet("key",nil) if type(kt)=="table" and type(kt.k)=="string" then KEY=kt.k end end
local users=dbGet("users",{})
if type(users)~="table" then users={} end
local U,chats,cur=nil,{},nil
local busy=false
local T0=os.time()
local AM=0
local PD=""
local CP=nil
local soonMode=false
local pend=nil
local cOn,cMute,cBusy,cT=false,false,false,0
local MD={
	{n="Manos Focus 1.0",d="dF",id="openai/gpt-oss-20b"},
	{n="Manos Granite 1.0",d="dG",soon=true},
	{n="Manos Sable 1.0",d="dS",id="openai/gpt-oss-120b"},
	{n="Manos Sonora 2.0",d="dN",id="openai/gpt-oss-120b",sys=true},
}
local EF={"low","medium","high","high","high"}
local FE={"web","mem","sug","typ","hist"}

local function trim(s) return (tostring(s or ""):gsub("^%s+",""):gsub("%s+$","")) end
local function cut(s,n)
	local l=utf8.len(s)
	if l and l>n then return s:sub(1,utf8.offset(s,n+1)-1) end
	return s
end
local function uname() if not U then return "" end return U.g and t("guestN") or (U.name or "") end
local function ckey() return "c_"..sha256(U and U.email or "x"):sub(1,16) end
local function sv2()
	if not S.hist then return end
	local o={}
	for i=1,math.min(30,#chats) do o[i]=chats[i] end
	dbSet(ckey(),o)
end

----------------------------------------------------------------- tema e font
local THEMES={
	dark={bg="161616",bg2="222222",bg3="2c2c2c",tx="ececec",mut="a3a19b",ac="d9775a",ln="363636",inv="f4f3ee",invt="161616",cb="0f0f0f"},
	light={bg="faf9f5",bg2="efede4",bg3="e4e1d6",tx="1f1e1d",mut="6b6a65",ac="d9775a",ln="d9d6ca",inv="1f1e1d",invt="faf9f5",cb="f4f2ea"},
}
local C={}
local FONT,FONTM,FONTB,FONTH,FONTC
local function F(a,b)
	local ok,v=pcall(function() return Enum.Font[a] end)
	if ok and v then return v end
	return Enum.Font[b or "SourceSans"]
end
local function applyTheme()
	local m=(S.th=="light") and "light" or "dark"
	for k,v in pairs(THEMES[m]) do C[k]=Color3.fromHex(v) end
	FONTH=F("Merriweather","Garamond")
	FONTC=F("RobotoMono","Code")
	if S.f=="sans" then FONT,FONTM,FONTB=Enum.Font.Arial,Enum.Font.Arial,Enum.Font.ArialBold
	elseif S.f=="serif" then FONT,FONTM,FONTB=FONTH,FONTH,FONTH
	elseif S.f=="mono" then FONT,FONTM,FONTB=FONTC,FONTC,FONTC
	else FONT,FONTM,FONTB=Enum.Font.Gotham,Enum.Font.GothamMedium,Enum.Font.GothamBold end
end
applyTheme()

----------------------------------------------------------------- helper UI
local ui={}
local function new(cls,props,parent)
	local o=Instance.new(cls)
	for k,v in pairs(props) do o[k]=v end
	if parent then o.Parent=parent end
	return o
end
local function corner(o,r) return new("UICorner",{CornerRadius=UDim.new(0,r)},o) end
local function pill(o) return new("UICorner",{CornerRadius=UDim.new(1,0)},o) end
local function stroke(o,c,th,tr) return new("UIStroke",{Color=c,Thickness=th or 1,Transparency=tr or 0,ApplyStrokeMode=Enum.ApplyStrokeMode.Border},o) end
local function pad(o,l,tp,r,b) return new("UIPadding",{PaddingLeft=UDim.new(0,l or 0),PaddingTop=UDim.new(0,tp or 0),PaddingRight=UDim.new(0,r or 0),PaddingBottom=UDim.new(0,b or 0)},o) end
local function vlist(o,gap,ha) return new("UIListLayout",{FillDirection=Enum.FillDirection.Vertical,Padding=UDim.new(0,gap or 0),SortOrder=Enum.SortOrder.LayoutOrder,HorizontalAlignment=ha or Enum.HorizontalAlignment.Left},o) end
local function hlist(o,gap,va,ha) return new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,gap or 0),SortOrder=Enum.SortOrder.LayoutOrder,VerticalAlignment=va or Enum.VerticalAlignment.Center,HorizontalAlignment=ha or Enum.HorizontalAlignment.Left},o) end
local function frame(parent,p)
	p=p or {}
	if p.BackgroundColor3==nil and p.BackgroundTransparency==nil then p.BackgroundTransparency=1 end
	p.BorderSizePixel=0
	if p.Size==nil then p.Size=UDim2.new(1,0,0,0) end
	return new("Frame",p,parent)
end
local XA,YA,XYA=Enum.AutomaticSize.X,Enum.AutomaticSize.Y,Enum.AutomaticSize.XY
local function lbl(parent,text,o)
	o=o or {}
	return new("TextLabel",{
		BackgroundTransparency=1,BorderSizePixel=0,Font=o.font or FONT,TextSize=o.size or 15,
		TextColor3=o.color or C.tx,TextXAlignment=o.xa or Enum.TextXAlignment.Left,
		TextYAlignment=o.ya or Enum.TextYAlignment.Center,TextWrapped=o.wrap==true,
		RichText=o.rt==true,Text=text or "",Size=o.sz or UDim2.new(0,0,0,0),
		AutomaticSize=(o.auto==nil) and XYA or o.auto,LayoutOrder=o.order or 0,
		TextTruncate=o.trunc or Enum.TextTruncate.None,LineHeight=o.lh or 1,
		AnchorPoint=o.anchor or Vector2.new(0,0),Position=o.pos or UDim2.new(0,0,0,0),
		ZIndex=o.z or 1,
	},parent)
end
local function btn(parent,o)
	o=o or {}
	local p={Text="",AutoButtonColor=false,BorderSizePixel=0,BackgroundTransparency=1,Size=UDim2.new(0,0,0,0)}
	for k,v in pairs(o) do p[k]=v end
	return new("TextButton",p,parent)
end
local function roundTopFill(f,color)
	-- riempimento per squadrare gli angoli inferiori (o superiori) di un riquadro arrotondato
	return frame(f,{AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,0,1,0),Size=UDim2.new(1,0,0.5,0),BackgroundColor3=color,ZIndex=0})
end
local function roundBotFill(f,color)
	return frame(f,{AnchorPoint=Vector2.new(0,0),Position=UDim2.new(0,0,0,0),Size=UDim2.new(1,0,0.5,0),BackgroundColor3=color,ZIndex=0})
end

----------------------------------------------------------------- icone (disegnate)
local function A(cx,cy,r,a0,a1,n)
	local o={} n=n or 10
	for i=0,n do
		local a=math.rad(a0+(a1-a0)*i/n)
		o[#o+1]=cx+r*math.cos(a) o[#o+1]=cy+r*math.sin(a)
	end
	return o
end
local function cat(...)
	local o={}
	for _,tb in ipairs({...}) do for _,v in ipairs(tb) do o[#o+1]=v end end
	return o
end
local moonPts=cat(A(11.8,12.2,8.5,254.3,15.7,16),A(17.68,6.32,8.5,74.2,195.8,10))
local ICONS={
	menu={{"l",3,7,21,7},{"l",3,12,15,12},{"l",3,17,9,17}},
	plus={{"l",12,5,12,19},{"l",5,12,19,12}},
	x={{"l",6,6,18,18},{"l",18,6,6,18}},
	bk={{"l",19,12,5,12},{"l",11,6,5,12},{"l",5,12,11,18}},
	chev={{"l",9,5,16,12},{"l",16,12,9,19}},
	chk={{"l",4,12,9,17},{"l",9,17,20,6}},
	up={{"l",12,19,12,5},{"l",5,12,12,5},{"l",19,12,12,5}},
	mic={{"r",9,3,6,11,3},{"p",A(12,11,7,0,180,10)},{"l",12,18,12,21}},
	phone={{"p",{5,4,9,4,11,9,8.5,10.5,9.4,12.2,10.7,13.6,12.2,14.7,13.5,15.5,15,13,20,15,20,19,18,21,14,20.5,10,19,6.5,15.5,4,11,3,6.5,3.5,5},true}},
	ghost={{"p",cat({5,20},{5,10},A(12,10,7,180,360,12),{19,20,16.7,18.2,14.3,20,12,18.2,9.7,20,7.3,18.2}),true},{"c",9.5,10.5,0.9,true},{"c",14.5,10.5,0.9,true}},
	eye={{"p",{2,12,5,8,8.5,5.7,12,5,15.5,5.7,19,8,22,12,19,16,15.5,18.3,12,19,8.5,18.3,5,16},true},{"c",12,12,3}},
	eyeoff={{"p",{2,12,5,8,8.5,5.7,12,5,15.5,5.7,19,8,22,12,19,16,15.5,18.3,12,19,8.5,18.3,5,16},true},{"c",12,12,3},{"l",4,20,20,4}},
	chat={{"p",{3,5,21,5,21,17,10,17,5,21,5,17,3,17},true}},
	pj={{"l",7,3,17,3},{"l",6,6.5,18,6.5},{"r",5,10,14,10,1}},
	code={{"p",{8,7,3,12,8,17}},{"p",{16,7,21,12,16,17}},{"l",14,5,10,19}},
	art={{"c",7,15,4},{"r",14,11,7,9,1},{"p",{6,3,10,9,2,9},true}},
	usr={{"c",12,12,9},{"c",12,10,3},{"p",{6.5,18,8.5,15.8,12,14.5,15.5,15.8,17.5,18}}},
	dol={{"c",12,12,9},{"p",{14.5,9.5,13.5,8.4,12,8,10.4,8.4,9.5,10,10.4,11.4,12,12,13.6,12.6,14.5,14,13.6,15.6,12,16,10.4,15.6,9.5,14.5}},{"l",12,6.5,12,17.5}},
	sl={{"l",6,4,6,20},{"l",12,4,12,20},{"l",18,4,18,20},{"c",6,9,2,true},{"c",12,15,2,true},{"c",18,8,2,true}},
	cn={{"r",4,12,7,7,1.5},{"r",13,12,7,7,1.5},{"r",4,3,7,7,1.5},{"l",16.5,3,16.5,9},{"l",13.5,6,19.5,6}},
	rb={{"p",cat({5,18,5,13},A(12,13,7,180,360,12),{19,18}),true},{"c",9.5,14,0.8,true},{"c",14.5,14,0.8,true},{"l",8,7,6.5,4.5},{"l",16,7,17.5,4.5}},
	key={{"c",8,15,4},{"l",11,12,20,3},{"l",16,7,19,10}},
	gl={{"c",12,12,9},{"l",3,12,21,12},{"p",{12,3,14.2,7,15,12,14.2,17,12,21}},{"p",{12,3,9.8,7,9,12,9.8,17,12,21}}},
	moon={{"p",moonPts,true}},
	ms={{"p",moonPts,true},{"l",17,4,17,8},{"l",15,6,19,6}},
	aa={{"p",{3,18,8,5,13,18}},{"l",5,13,11,13},{"p",{15,18,18.5,10,21.5,18}},{"l",16.3,15.5,20.7,15.5}},
	wv={{"l",4,10,4,14},{"l",8,7,8,17},{"l",12,4,12,20},{"l",16,7,16,17},{"l",20,10,20,14}},
	ph={{"r",8,4,8,16,2},{"l",5,9,5,15},{"l",19,9,19,15}},
	bell={{"p",cat({6,17,6,11},A(12,11,6,180,360,12),{18,17,19.5,19,4.5,19}),true},{"l",10,21,14,21}},
	shd={{"p",{12,3,19,6,19,12,17,17,12,21,7,17,5,12,5,6},true},{"r",9.5,10.5,5,4,1}},
	shr={{"l",12,15,12,4},{"p",{8,8,12,4,16,8}},{"p",{5,13,5,20,19,20,19,13}}},
	ex={{"p",{10,4,5,4,5,20,10,20}},{"p",{14,8,18,12,14,16}},{"l",18,12,9,12}},
	cam={{"p",{4,8,7,8,8.5,6,15.5,6,17,8,20,8,20,19,4,19},true},{"c",12,13,3.5}},
	pic={{"r",4,4,16,16,2},{"c",9,9,1.5},{"p",{4,17,9,12,13,16,16,13,20,17}}},
	fl={{"p",{7,3,14,3,18,7,18,21,7,21},true},{"l",12,17,12,12},{"p",{9.5,14,12,11.5,14.5,14}}},
	br={{"p",cat(A(12,9,6,125,415,16),{15,17,9,17}),true},{"l",10,20,14,20}},
	info={{"c",12,12,9},{"l",12,11,12,17},{"c",12,7.5,0.8,true}},
	cp={{"r",9,9,11,11,2},{"p",{5,15,5,6.5,6,5,7.5,4,15,4}}},
	logo={vb=48,th=5.5,{"p",{9,38,9,10,24,27,39,10,39,38}}},
}
local function seg(root,k,th,color,x1,y1,x2,y2)
	x1,y1,x2,y2=x1*k,y1*k,x2*k,y2*k
	local dx,dy=x2-x1,y2-y1
	local len=math.sqrt(dx*dx+dy*dy)
	local f=new("Frame",{BackgroundColor3=color,BorderSizePixel=0,AnchorPoint=Vector2.new(0.5,0.5),
		Position=UDim2.fromOffset((x1+x2)/2,(y1+y2)/2),Size=UDim2.fromOffset(len+th,th),Rotation=math.deg(math.atan2(dy,dx))},root)
	pill(f)
end
local function Icon(name,parent,size,color,o)
	o=o or {}
	local def=ICONS[name]
	local vb=def.vb or 24
	local k=size/vb
	local th=math.max(1.4,(o.th or def.th or 1.7)*k)
	local root=new("Frame",{BackgroundTransparency=1,BorderSizePixel=0,Size=UDim2.fromOffset(size,size),
		AnchorPoint=o.anchor or Vector2.new(0,0),Position=o.pos or UDim2.new(0,0,0,0),Rotation=o.rot or 0,LayoutOrder=o.order or 0,ZIndex=o.z or 1},parent)
	for _,it in ipairs(def) do
		local ty=it[1]
		if ty=="l" then
			seg(root,k,th,color,it[2],it[3],it[4],it[5])
		elseif ty=="p" then
			local p=it[2]
			local n=#p/2
			for i=1,n-1 do seg(root,k,th,color,p[i*2-1],p[i*2],p[i*2+1],p[i*2+2]) end
			if it[3] then seg(root,k,th,color,p[n*2-1],p[n*2],p[1],p[2]) end
		elseif ty=="c" then
			local r=it[4]
			local d=math.max(2*r*k,th)
			local f=new("Frame",{BorderSizePixel=0,AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromOffset(it[2]*k,it[3]*k),Size=UDim2.fromOffset(d,d)},root)
			pill(f)
			if it[5] then f.BackgroundColor3=color else f.BackgroundTransparency=1 stroke(f,color,th) end
		elseif ty=="r" then
			local f=new("Frame",{BorderSizePixel=0,BackgroundTransparency=1,Position=UDim2.fromOffset(it[2]*k,it[3]*k),Size=UDim2.fromOffset(it[4]*k,it[5]*k)},root)
			corner(f,(it[6] or 0)*k)
			stroke(f,color,th)
		end
	end
	return root
end

----------------------------------------------------------------- forward
local rebuild,renderMsgs,list,refresh,show,chipUpd,greet,menu,fresh,openSet,closeSh,rs,rset,panel
local keyp,models,effort,addp,connp,planp,speak,stopSpeak,enter,logout,startCall,endCall,sgs,setTab,scrollBottom,SM

local function getReq() return request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request) end

----------------------------------------------------------------- toast / notifiche
local toastTok=0
local function toast(s)
	toastTok=toastTok+1
	local my=toastTok
	if not (ui.ttp and ui.ttp.Parent) then return end
	ui.tt.Text=s
	ui.ttp.Visible=true
	task.delay(2.4,function()
		if my==toastTok and ui.ttp and ui.ttp.Parent then ui.ttp.Visible=false end
	end)
end
local function ntf(x)
	if not S["not"] then return end
	pcall(function() StarterGui:SetCore("SendNotification",{Title="Manos AI",Text=cut(x,90),Duration=5}) end)
end

----------------------------------------------------------------- sintesi vocale (TTS)
local speakTok=0
local curSound=nil
local ttsN=0
local warnedTTS=false
stopSpeak=function()
	speakTok=speakTok+1
	if curSound then pcall(function() curSound:Stop() curSound:Destroy() end) curSound=nil end
end
local function ttsClean(x)
	x=x:gsub("```.-```"," ")
	x=x:gsub("[%*#_`>~|]","")
	x=x:gsub("%s+"," ")
	return trim(x)
end
local function chunkText(x)
	local out={}
	local curc=""
	for piece in x:gmatch("[^%.%!%?;:\n]+[%.%!%?;:]*") do
		piece=trim(piece)
		if piece~="" then
			while #piece>180 do
				local sp=nil
				for i=180,100,-1 do if piece:sub(i,i)==" " then sp=i break end end
				sp=sp or 180
				if #curc>0 then out[#out+1]=curc curc="" end
				out[#out+1]=piece:sub(1,sp)
				piece=trim(piece:sub(sp+1))
			end
			if #curc+#piece+1<=180 then curc=(curc=="" and piece) or (curc.." "..piece)
			else
				if curc~="" then out[#out+1]=curc end
				curc=piece
			end
		end
	end
	if curc~="" then out[#out+1]=curc end
	return out
end
speak=function(x,done)
	done=done or function() end
	stopSpeak()
	local tok=speakTok
	local reqf=getReq()
	local ga=getcustomasset or getsynasset
	if not (reqf and ga and fsOK) then
		if not warnedTTS then warnedTTS=true toast(t("noTTS")) end
		task.delay(0.6,done)
		return
	end
	task.spawn(function()
		local chunks=chunkText(ttsClean(x))
		local lang=(L==1) and "en" or "it"
		local played=false
		for _,chv in ipairs(chunks) do
			if tok~=speakTok then return end
			local ok,res=pcall(reqf,{Url="https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&tl="..lang.."&q="..HttpService:UrlEncode(chv),Method="GET",Headers={["User-Agent"]="Mozilla/5.0"}})
			if ok and type(res)=="table" and type(res.Body)=="string" and #res.Body>200 then
				ttsN=ttsN+1
				local fn=FOLDER.."/tts_"..tostring(os.time()).."_"..ttsN..".mp3"
				local w=pcall(writefile,fn,res.Body)
				if w then
					local okA,asset=pcall(ga,fn)
					if okA and asset then
						local s=Instance.new("Sound")
						s.SoundId=asset s.Volume=1 s.PlaybackSpeed=S.rate or 1
						s.Parent=workspace
						curSound=s
						local ended=false
						s.Ended:Connect(function() ended=true end)
						local t0=os.clock()
						while not s.IsLoaded and os.clock()-t0<6 and tok==speakTok do task.wait(0.1) end
						if s.IsLoaded and tok==speakTok then
							played=true
							s:Play()
							local t1=os.clock()
							local lim=(s.TimeLength>0 and (s.TimeLength/(S.rate or 1)+2)) or 15
							while not ended and tok==speakTok and os.clock()-t1<lim do task.wait(0.1) end
						end
						pcall(function() s:Destroy() end)
					end
					if type(delfile)=="function" then pcall(delfile,fn) end
				end
			end
		end
		if not played and not warnedTTS then warnedTTS=true toast(t("noTTS")) end
		if tok==speakTok then done() end
	end)
end

----------------------------------------------------------------- Groq
local function post(b,cb)
	local reqf=getReq()
	if not reqf then cb(nil,nil,t("noReq")) return end
	task.spawn(function()
		local ok,res=pcall(reqf,{Url="https://api.groq.com/openai/v1/chat/completions",Method="POST",
			Headers={["Content-Type"]="application/json",["Authorization"]="Bearer "..KEY},Body=HttpService:JSONEncode(b)})
		if not ok or type(res)~="table" then cb(nil,nil,t("eNet")) return end
		local status=tonumber(res.StatusCode or res.Status or 0) or 0
		local j=nil
		pcall(function() j=HttpService:JSONDecode(res.Body) end)
		if status>=200 and status<300 and type(j)=="table" and type(j.choices)=="table" and j.choices[1] then
			local m=j.choices[1].message or {}
			local c=m.content
			if type(c)~="string" or c=="" then c="..." end
			local r=m.reasoning or m.reasoning_content
			if type(r)~="string" then r="" end
			cb(c,r,nil)
			return
		end
		if b.tools then b.tools=nil post(b,cb) return end
		local em=""
		if type(j)=="table" and type(j.error)=="table" and type(j.error.message)=="string" then em=j.error.message end
		cb(nil,nil,status==401 and t("e401") or (t("eGroq").." ("..tostring(status).."): "..em))
	end)
end
local function mkb()
	local m=MD[S.cm+1] or MD[1]
	if m.soon then m=MD[1] end
	local src=cur.m
	local from=S.mem and math.max(1,#src-11) or #src
	local msgsT={{role="system",content=(m.sys and SON or SYS).."\n\n"..((L==1) and "Default UI language: English. Reply in the language the user writes in." or "Lingua predefinita dell'interfaccia: italiano. Rispondi nella lingua in cui scrive l'utente.")}}
	for i=from,#src do
		local x=src[i]
		msgsT[#msgsT+1]={role=(x.r=="u") and "user" or "assistant",content=x.t}
	end
	local b={model=m.id,messages=msgsT,max_tokens=m.sys and 3500 or 1500,reasoning_effort=m.sys and "high" or EF[S.li+1]}
	if S.web then b.tools={{type="browser_search"}} end
	return b
end
local function ask(cb) post(mkb(),cb) end

----------------------------------------------------------------- righe / pannelli
local FIELDS={}
local function mkInput(parent,o)
	local pl,pr=o.pl or 14,o.pr or 14
	local w=frame(parent,{Size=o.sz or UDim2.new(1,0,0,46),LayoutOrder=o.order or 0})
	local tb=new("TextBox",{BackgroundTransparency=1,BorderSizePixel=0,Position=UDim2.new(0,pl,0,0),Size=UDim2.new(1,-(pl+pr),1,0),
		ClearTextOnFocus=false,Text=o.val or "",PlaceholderText=o.ph or "",PlaceholderColor3=C.mut,TextColor3=C.tx,
		Font=o.pw and FONTC or FONT,TextSize=o.size or 16,TextXAlignment=Enum.TextXAlignment.Left,ClipsDescendants=true,MultiLine=false},w)
	local api={}
	if o.pw then
		local ov=lbl(w,"",{font=FONTC,size=o.size or 16,color=C.tx,pos=UDim2.new(0,pl,0,0),sz=UDim2.new(1,-(pl+pr),1,0),auto=Enum.AutomaticSize.None,z=2})
		ov.Active=false
		local masked=true
		local function upd() if masked then ov.Text=string.rep("*",utf8.len(tb.Text) or #tb.Text) else ov.Text="" end end
		tb.TextTransparency=1
		tb:GetPropertyChangedSignal("Text"):Connect(upd)
		upd()
		function api.toggle() masked=not masked tb.TextTransparency=masked and 1 or 0 upd() return masked end
	end
	return tb,w,api
end

local function mkSwitch(parent,on)
	local sw=frame(parent,{Size=UDim2.fromOffset(44,26),BackgroundColor3=on and Color3.fromRGB(47,107,255) or Color3.fromRGB(119,119,119),AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-14,0.5,0)})
	pill(sw)
	local k=frame(sw,{Size=UDim2.fromOffset(20,20),BackgroundColor3=Color3.new(1,1,1),Position=UDim2.fromOffset(on and 21 or 3,3)})
	pill(k)
	return sw
end

local function act(r,rr)
	if r.sw then
		S[r.sw]=not S[r.sw]
		sv()
		if r.on then r.on() end
		rr()
		refresh()
	elseif r.fn then
		r.fn()
	end
end

local function mkRow(grp,r,first,last,rr)
	local row=btn(grp,{Size=UDim2.new(1,0,0,0),AutomaticSize=YA,BackgroundTransparency=0,BackgroundColor3=C.bg2})
	if first or last then corner(row,16) end
	if first and not last then roundTopFill(row,C.bg2) end
	if last and not first then roundBotFill(row,C.bg2) end
	local x0=14
	if r.ic then
		local ri=frame(row,{Size=UDim2.fromOffset(34,34),BackgroundColor3=C.bg3,AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,14,0.5,0)})
		pill(ri)
		Icon(r.ic,ri,20,C.tx,{anchor=Vector2.new(0.5,0.5),pos=UDim2.new(0.5,0,0.5,0)})
		x0=14+46
	end
	-- widget a destra
	local rx=14
	if r.ch then
		Icon("chev",row,16,Color3.fromHex("9a9890"),{anchor=Vector2.new(1,0.5),pos=UDim2.new(1,-rx,0.5,0)})
		rx=rx+16+6
	end
	if r.chk then
		Icon("chk",row,22,Color3.fromHex("6ea4ff"),{anchor=Vector2.new(1,0.5),pos=UDim2.new(1,-rx,0.5,0),th=2})
		rx=rx+22+6
	end
	if r.sw then
		local sw=mkSwitch(row,S[r.sw] and true or false)
		sw.Position=UDim2.new(1,-rx,0.5,0)
		rx=rx+44+6
	end
	if r.em then
		lbl(row,r.em,{size=14,color=C.mut,anchor=Vector2.new(1,0.5),pos=UDim2.new(1,-rx,0.5,0)})
		rx=rx+TextService:GetTextSize(r.em,14,FONT,Vector2.new(1000,100)).X+8
		if rx<30 then rx=30 end
	end
	local col=frame(row,{Position=UDim2.new(0,x0,0,0),Size=UDim2.new(1,-(x0+rx+4),0,0),AutomaticSize=YA})
	pad(col,0,12,0,12)
	vlist(col,2)
	local tr=frame(col,{AutomaticSize=XYA,Size=UDim2.new(0,0,0,0),LayoutOrder=0})
	hlist(tr,8)
	lbl(tr,r.l or "",{size=15,color=r.red and Color3.fromHex("e0706a") or C.tx,font=FONT,order=0})
	if r.tag then
		local tg=frame(tr,{AutomaticSize=XYA,Size=UDim2.new(0,0,0,0),BackgroundColor3=r.warn and Color3.fromHex("3a2a10") or Color3.fromHex("23324d"),LayoutOrder=1})
		pill(tg) pad(tg,8,2,8,2)
		lbl(tg,r.tag,{size=10.5,color=r.warn and Color3.fromHex("f0a020") or Color3.fromHex("7fb0ff"),font=FONTM})
	end
	if r.sub then
		lbl(col,r.sub,{size=12.5,color=C.mut,wrap=true,sz=UDim2.new(1,0,0,0),auto=YA,order=1,lh=1.1})
	end
	if r.fn or r.sw then
		row.Activated:Connect(function() act(r,rr) end)
	end
	return row
end

local function renderRows(host,groups,rr)
	FIELDS={}
	for _,g in ipairs(groups) do
		if type(g)=="string" then
			local f=frame(host,{AutomaticSize=YA})
			pad(f,6,0,6,0)
			lbl(f,g,{size=13,color=C.mut,wrap=true,sz=UDim2.new(1,0,0,0),auto=YA,lh=1.1})
		elseif g.mail then
			local f=frame(host,{AutomaticSize=YA,BackgroundTransparency=0,BackgroundColor3=C.bg}) corner(f,16) stroke(f,C.ln,1)
			local hh=frame(f,{Size=UDim2.new(1,0,0,48)})
			lbl(hh,g.email,{size=15,pos=UDim2.new(0,14,0.5,0),anchor=Vector2.new(0,0.5),sz=UDim2.new(1,-90,0,20),auto=Enum.AutomaticSize.None,trunc=Enum.TextTruncate.AtEnd})
			local fr=frame(hh,{AutomaticSize=XYA,Size=UDim2.new(0,0,0,0),BackgroundColor3=C.inv,AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-14,0.5,0)})
			pill(fr) pad(fr,12,5,12,5)
			lbl(fr,"Free",{size=12,color=C.invt,font=FONTB})
		else
			local normals=0
			for _,r in ipairs(g) do if not r.tiles and not r.promo and not r.inp then normals=normals+1 end end
			local grp,idx=nil,0
			for _,r in ipairs(g) do
				if r.tiles then
					grp=nil
					local tl=frame(host,{Size=UDim2.new(1,0,0,96)})
					new("UIGridLayout",{CellSize=UDim2.new(1/3,-6,0,92),CellPadding=UDim2.new(0,8,0,8),SortOrder=Enum.SortOrder.LayoutOrder},tl)
					local defs={{"cam","cam"},{"pic","pho"},{"fl","fil"}}
					for i,d in ipairs(defs) do
						local b=btn(tl,{BackgroundTransparency=0,BackgroundColor3=C.bg2,LayoutOrder=i})
						corner(b,14)
						local c=frame(b,{Size=UDim2.fromOffset(42,42),BackgroundColor3=C.bg3,AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(0.5,0,0,14)})
						pill(c)
						Icon(d[1],c,22,C.tx,{anchor=Vector2.new(0.5,0.5),pos=UDim2.new(0.5,0,0.5,0)})
						lbl(b,t(d[2]),{size=13,anchor=Vector2.new(0.5,1),pos=UDim2.new(0.5,0,1,-10)})
						b.Activated:Connect(function() toast(t("attNo")) end)
					end
				elseif r.promo then
					grp=nil
					local pr=frame(host,{AutomaticSize=YA}) corner(pr,16) stroke(pr,C.ln,1) pad(pr,16,16,16,16) vlist(pr,6)
					lbl(pr,t("promoT"),{size=16,font=FONTB,order=0})
					lbl(pr,t("promoP"),{size=14,wrap=true,sz=UDim2.new(1,0,0,0),auto=YA,order=1,lh=1.1})
					local sp=frame(pr,{Size=UDim2.new(1,0,0,6),LayoutOrder=2})
					local b=btn(pr,{AutomaticSize=XYA,BackgroundTransparency=0,BackgroundColor3=C.inv,LayoutOrder=3})
					pill(b) pad(b,18,9,18,9)
					lbl(b,t("chPlan"),{size=14,color=C.invt,font=FONTM})
					b.Activated:Connect(function() if r.fn then r.fn() end end)
				elseif r.inp then
					grp=nil
					local bx=frame(host,{BackgroundTransparency=0,BackgroundColor3=C.bg2,Size=UDim2.new(1,0,0,46)}) corner(bx,16)
					local tb,_,api=mkInput(bx,{ph=r.ph,val=r.val,pw=r.pw,pr=(r.pw and 50 or 14)})
					FIELDS[r.inp]=tb
					if r.pw then
						local eb=btn(bx,{Size=UDim2.fromOffset(36,36),AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-6,0.5,0),ZIndex=3})
						local holder=frame(eb,{Size=UDim2.fromOffset(20,20),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,0)})
						local function draw(masked)
							for _,c in ipairs(holder:GetChildren()) do c:Destroy() end
							Icon(masked and "eye" or "eyeoff",holder,20,C.mut)
						end
						draw(true)
						eb.Activated:Connect(function() draw(api.toggle()) end)
					end
				else
					if not grp then
						grp=frame(host,{AutomaticSize=YA})
						vlist(grp,2)
					end
					idx=idx+1
					mkRow(grp,r,idx==1,idx==normals,rr)
				end
			end
		end
	end
end

-- foglio inferiore
panel=function(ti,fn,back)
	CP={ti=ti,fn=fn,back=back}
	rs()
end
rs=function()
	if not CP or not ui.sheet then return end
	local wasVisible=ui.sheet.Visible
	local pos=ui.pnBody.CanvasPosition
	for _,c in ipairs(ui.pnBody:GetChildren()) do if c:IsA("GuiObject") then c:Destroy() end end
	for _,c in ipairs(ui.pnClose:GetChildren()) do c:Destroy() end
	Icon(CP.back and "bk" or "x",ui.pnClose,22,C.tx,{anchor=Vector2.new(0.5,0.5),pos=UDim2.new(0.5,0,0.5,0)})
	ui.pnTitle.Text=CP.ti
	local content=frame(ui.pnBody,{AutomaticSize=YA})
	pad(content,12,0,12,16) vlist(content,12)
	renderRows(content,CP.fn(),rs)
	local function fit()
		local h=math.min(ui.vp.Y*0.9,56+content.AbsoluteSize.Y)
		ui.pn.Size=UDim2.new(0,ui.pnW,0,h+24)
	end
	content:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit)
	ui.sheet.Visible=true
	if not wasVisible then
		ui.pn.Position=UDim2.new(0.5,0,1,90)
		TweenService:Create(ui.pn,TweenInfo.new(0.22,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=UDim2.new(0.5,0,1,24)}):Play()
	end
	task.defer(function() fit() if ui.pnBody and ui.pnBody.Parent then ui.pnBody.CanvasPosition=pos end end)
end
closeSh=function()
	if ui.sheet then ui.sheet.Visible=false end
	CP=nil
end
rset=function()
	if not ui.stb then return end
	local pos=ui.stb.CanvasPosition
	for _,c in ipairs(ui.stb:GetChildren()) do if c:IsA("GuiObject") then c:Destroy() end end
	local content=frame(ui.stb,{AutomaticSize=YA})
	pad(content,12,8,12,20) vlist(content,12)
	renderRows(content,SM(),rset)
	task.defer(function() if ui.stb and ui.stb.Parent then ui.stb.CanvasPosition=pos end end)
end

----------------------------------------------------------------- pannelli (porting 1:1)
local function stOn() return ui.st and ui.st.Visible end
keyp=function(back)
	panel(t("keyT"),function()
		local rows={{l=t("save"),fn=function()
			local v=trim(FIELDS.ki and FIELDS.ki.Text or "")
			if not (v:match("^gsk_%w+$") and #v>=24) then toast(t("keyBad")) return end
			KEY=v dbSet("key",{k=v})
			closeSh() toast(t("keyOk"))
			if stOn() then rset() end
		end}}
		if KEY~="" then
			rows[#rows+1]={l=t("rm"),red=true,fn=function()
				KEY="" dbDel("key") closeSh() toast(t("keyRm"))
				if stOn() then rset() end
			end}
		end
		return {t("keyMsg"),{{inp="ki",ph="gsk_...",pw=true}},rows,t("keyHelp")}
	end,back)
end
models=function()
	panel(t("modT"),function()
		local g1={}
		for i,m in ipairs(MD) do
			g1[#g1+1]={l=m.n,tag=m.soon and t("sT") or nil,sub=t(m.d),chk=((i-1)==S.cm),fn=function()
				if m.soon then toast(t("grSoon")) return end
				S.cm=i-1 sv() chipUpd() closeSh()
			end}
		end
		return {g1,{{l=t("eff"),tag=t("recm"),em=t("e"..S.li),ch=true,fn=function() effort() end}},{{l=t("oth"),ch=true,fn=function() toast(t("noOth")) end}}}
	end)
end
effort=function()
	panel(t("eff"),function()
		local g={}
		for i=0,4 do
			g[#g+1]={l=t("e"..i),tag=(i==1) and t("recm") or ((i==4) and t("use5") or nil),warn=(i==4),chk=(i==S.li),fn=function() S.li=i sv() chipUpd() rs() end}
		end
		return {g,t("effN")}
	end,function() models() end)
end
connp=function(back)
	panel(t("conn"),function()
		local g={}
		for _,n in ipairs({"Google Drive","GitHub","Gmail","Notion"}) do
			g[#g+1]={l=n,tag=t("sT"),fn=function() toast(t("soon")) end}
		end
		return {g}
	end,back)
end
addp=function()
	panel(t("addT"),function()
		return {
			{{tiles=true}},
			{{ic="pj",l=t("addP"),sub=t("none"),ch=true,fn=function() toast(t("soon")) end}},
			{{ic="gl",l=t("web"),sw="web"},{ic="cn",l=t("conn"),ch=true,fn=function() connp(function() addp() end) end},{ic="br",l=t("mem"),sw="mem"}},
		}
	end)
end
planp=function()
	panel(t("chPlan"),function()
		return {{
			{ic="usr",l="Free",sub=t("plan0"),chk=true},
			{ic="usr",l="Pro",sub=t("pPro"),tag=t("sT"),fn=function() toast(t("soon")) end},
			{ic="usr",l="Max",sub=t("pMax"),tag=t("sT"),fn=function() toast(t("soon")) end},
		}}
	end)
end
local function profp()
	if U.g then toast(t("gProf")) return end
	panel(t("profile"),function()
		return {
			{{inp="pn1",val=U.name,ph=t("name")}},
			{{ic="usr",l="Email",sub=U.email}},
			{{l=t("save"),fn=function()
				local v=trim(FIELDS.pn1 and FIELDS.pn1.Text or "")
				if v=="" then return end
				U.name=v
				if users[U.email] then users[U.email].name=v end
				dbSet("users",users)
				greet() ui.av.Text=cut(v,1):upper()
				closeSh() toast(t("pSaved"))
			end}},
		}
	end)
end
local function billp()
	panel(t("billing"),function()
		return {{{ic="dol",l="Free",sub=t("noPay"),chk=true}},{{l=t("chPlan"),ch=true,fn=function() planp() end}}}
	end)
end
local function featp()
	panel(t("feat"),function()
		local g={}
		for _,k in ipairs(FE) do g[#g+1]={l=t("ft_"..k),sub=t("fd_"..k),sw=k} end
		return {g}
	end)
end
local function askMic() S.mic="granted" sv() toast(t("micOk")) if CP then rs() end end
local function askNot() toast(t("notOk")) if CP then rs() end end
local function permp()
	panel(t("perm"),function()
		return {{{ic="wv",l=t("mic"),sub=t("st_"..S.mic),fn=askMic},{ic="bell",l=t("not"),sub=t("st_granted"),fn=askNot}}}
	end)
end
local function langp()
	panel(t("lang"),function()
		return {{{l="Italiano",chk=(L==0),fn=function() rebuild(0) end},{l="English",chk=(L==1),fn=function() rebuild(1) end}}}
	end)
end
local function chp(ti,key,opts,after)
	panel(ti,function()
		local g={}
		for _,o in ipairs(opts) do
			g[#g+1]={l=o[2],chk=(S[key]==o[1]),fn=function()
				S[key]=o[1] sv()
				if after then after() end
				if CP then rs() end
				if stOn() then rset() end
			end}
		end
		return {g}
	end)
end
local function thp() chp(t("cm"),"th",{{"system",t("system")},{"light",t("light")},{"dark",t("dark")}},function() rebuild() end) end
local function fontp() chp(t("font"),"f",{{"def",t("f_def")},{"sans",t("f_sans")},{"serif",t("f_serif")},{"mono",t("f_mono")}},function() rebuild() end) end
local function voicep()
	panel(t("voice"),function()
		return {
			{{ic="wv",l=t("spk"),sw="speak"}},
			{{l=t("r1"),chk=(S.rate==0.8),fn=function() S.rate=0.8 sv() rs() end},
			 {l=t("r2"),chk=(S.rate==1),fn=function() S.rate=1 sv() rs() end},
			 {l=t("r3"),chk=(S.rate==1.25),fn=function() S.rate=1.25 sv() rs() end}},
			{{l=t("tst"),fn=function() speak(t("hello")) end}},
		}
	end)
end
local function notip()
	panel(t("not"),function()
		return {{{ic="bell",l=t("notRep"),sub=t("notD"),sw="not",on=function() if S["not"] then askNot() end end}},{{l=t("not"),sub=t("st_granted"),fn=askNot}}}
	end)
end
local function focp()
	panel(t("foc"),function()
		local g={}
		for _,o in ipairs({{0,t("brk0")},{15,"15 min"},{30,"30 min"},{60,"60 min"}}) do
			g[#g+1]={l=t("brkT").." · "..o[2],chk=(S.brk==o[1]),fn=function() S.brk=o[1] T0=os.time() sv() rs() end}
		end
		return {{{ic="ms",l=t("sess",math.floor((os.time()-T0)/60))}},g}
	end)
end
local function cf(k,fn)
	if PD==k then PD="" fn()
	else
		PD=k toast(t("again"))
		task.delay(3,function() PD="" end)
	end
end
local function privp()
	panel(t("priv"),function()
		return {
			{{ic="shd",l=t("ft_hist"),sub=t("fd_hist"),sw="hist",on=function() if not S.hist then dbDel(ckey()) else sv2() end end}},
			{{l=t("clr"),red=true,fn=function() cf("c",function()
				chats={} cur=nil sv2() dbDel(ckey()) list() renderMsgs() closeSh() toast(t("cleared"))
			end) end},
			{l=t("delAcc"),red=true,fn=function() cf("d",function()
				dbDel(ckey())
				if not U.g then users[U.email]=nil dbSet("users",users) end
				logout()
			end) end}},
		}
	end)
end
local function share()
	if setclipboard then pcall(setclipboard,t("shT")) end
	toast(t("copied"))
end
local function aboutp()
	panel(t("about"),function()
		return {{{l="Manos AI",sub=t("ver").." 1.0"},{l="Focus 1.0 · Sable 1.0 · Sonora 2.0",sub="Groq"}}}
	end)
end
SM=function()
	local n=0
	for _,k in ipairs(FE) do if S[k] then n=n+1 end end
	return {
		{mail=true,email=U.g and t("guestN") or U.email},
		{{promo=true,fn=function() planp() end}},
		{{ic="usr",l=t("profile"),ch=true,fn=profp},{ic="dol",l=t("billing"),ch=true,fn=billp}},
		{{ic="sl",l=t("feat"),sub=n.." "..t("on"),ch=true,fn=featp},
		 {ic="cn",l=t("conn"),ch=true,fn=function() connp() end},
		 {ic="rb",l=t("perm"),ch=true,fn=permp},
		 {ic="key",l=t("apiKey"),sub=(KEY~="") and t("set") or t("notset"),ch=true,fn=function() keyp() end},
		 {ic="gl",l=t("lang"),sub=(L==1) and "English" or "Italiano",ch=true,fn=langp}},
		{{ic="moon",l=t("cm"),sub=t(S.th),ch=true,fn=thp},{ic="aa",l=t("font"),sub=t("f_"..S.f),ch=true,fn=fontp},{ic="wv",l=t("voice"),ch=true,fn=voicep}},
		{{ic="ph",l=t("hap"),sw="hap"},{ic="bell",l=t("not"),ch=true,fn=notip},{ic="ms",l=t("foc"),ch=true,fn=focp},{ic="shd",l=t("priv"),ch=true,fn=privp},{ic="shr",l=t("shr"),ch=true,fn=share}},
		{{ic="ex",l=t("out"),red=true,fn=function() logout() end}},
	}
end

----------------------------------------------------------------- chat: rendering
local doSend
local function parseRich(x)
	local parts,pos={},1
	while true do
		local s,e=x:find("```",pos,true)
		if not s then parts[#parts+1]=x:sub(pos) break end
		parts[#parts+1]=x:sub(pos,s-1)
		pos=e+1
	end
	local segs={}
	for idx,s in ipairs(parts) do
		if idx%2==1 then
			if idx>1 then s=s:gsub("^\n","") end
			if s~="" then segs[#segs+1]={text=s} end
		else
			local n=s:find("\n",1,true)
			local lg,c="",s
			if n then
				lg=trim(s:sub(1,n-1))
				c=s:sub(n+1)
				if #lg>20 or not lg:match("^[%w%+#%.%-_]*$") then lg="" c=s end
			end
			c=c:gsub("\n$","")
			segs[#segs+1]={code=c,lang=lg}
		end
	end
	return segs
end
local function codeBlock(parent,lang,code,order)
	local b=frame(parent,{BackgroundColor3=C.cb,AutomaticSize=YA,LayoutOrder=order})
	corner(b,12) stroke(b,C.ln,1) vlist(b,0)
	local h=frame(b,{Size=UDim2.new(1,0,0,32),BackgroundColor3=C.bg3,LayoutOrder=0})
	corner(h,12) roundTopFill(h,C.bg3)
	lbl(h,(lang~="" and lang or "code"),{size=12,color=C.mut,pos=UDim2.new(0,12,0.5,0),anchor=Vector2.new(0,0.5),font=FONTC})
	local cp=btn(h,{AutomaticSize=XYA,AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-6,0.5,0)})
	corner(cp,8) pad(cp,10,5,10,5)
	local cl=lbl(cp,t("cpy"),{size=12})
	cp.Activated:Connect(function()
		local ok=false
		if setclipboard then ok=pcall(setclipboard,code) end
		cl.Text=t(ok and "cpd" or "cpf")
		task.delay(1.5,function() if cl.Parent then cl.Text=t("cpy") end end)
	end)
	local ts=TextService:GetTextSize(code,13,FONTC,Vector2.new(100000,100000))
	local sc=new("ScrollingFrame",{BackgroundTransparency=1,BorderSizePixel=0,Size=UDim2.new(1,0,0,ts.Y+24),CanvasSize=UDim2.new(0,ts.X+28,0,0),
		ScrollingDirection=Enum.ScrollingDirection.X,ScrollBarThickness=3,ScrollBarImageColor3=C.ln,LayoutOrder=1},b)
	local cl2=lbl(sc,code,{font=FONTC,size=13,pos=UDim2.new(0,12,0,12),sz=UDim2.new(0,ts.X+4,0,ts.Y),auto=Enum.AutomaticSize.None,ya=Enum.TextYAlignment.Top})
	return b,cl2
end
local function rich(parent,x)
	local labels,order={},0
	for _,sg in ipairs(parseRich(x)) do
		order=order+1
		if sg.code then
			local _,cl=codeBlock(parent,sg.lang,sg.code,order)
			labels[#labels+1]=cl
		else
			labels[#labels+1]=lbl(parent,sg.text,{wrap=true,sz=UDim2.new(1,0,0,0),auto=YA,size=15,lh=1.15,order=order,ya=Enum.TextYAlignment.Top})
		end
	end
	return labels
end
local function mkThink(w,o)
	local T={}
	local open=false
	local e=frame(w,{BackgroundColor3=C.bg2,AutomaticSize=YA,LayoutOrder=0})
	corner(e,14) stroke(e,C.ln,1) vlist(e,0)
	local hh=btn(e,{Size=UDim2.new(1,0,0,36),LayoutOrder=0})
	local dot=frame(hh,{Size=UDim2.fromOffset(12,12),Position=UDim2.new(0,12,0.5,0),AnchorPoint=Vector2.new(0,0.5)})
	pill(dot)
	local dst=stroke(dot,C.ac,2)
	local tt=lbl(hh,"",{size=12.5,color=C.mut,font=FONTM,pos=UDim2.new(0,32,0.5,0),anchor=Vector2.new(0,0.5)})
	local chev=Icon("chev",hh,14,C.mut,{anchor=Vector2.new(1,0.5),pos=UDim2.new(1,-12,0.5,0),rot=90})
	local bodyF=frame(e,{AutomaticSize=YA,LayoutOrder=1,Visible=false})
	pad(bodyF,12,0,12,12) vlist(bodyF,10)
	local ol=frame(bodyF,{AutomaticSize=YA,LayoutOrder=0})
	vlist(ol,7)
	local sd,stx,pulses={},{},{}
	for i,s in ipairs({t("st1"),t("st2"),t("st3")}) do
		local li=frame(ol,{Size=UDim2.new(1,0,0,16),LayoutOrder=i})
		local c=frame(li,{Size=UDim2.fromOffset(9,9),AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,0,0.5,0)})
		pill(c)
		local cs=stroke(c,C.mut,2)
		stx[i]=lbl(li,s,{size=12.5,color=C.mut,pos=UDim2.new(0,18,0.5,0),anchor=Vector2.new(0,0.5)})
		sd[i]={c=c,s=cs}
	end
	local dotTw=nil
	function T.step(n)
		for i=1,3 do
			local d=sd[i]
			if pulses[i] then pulses[i]:Cancel() pulses[i]=nil end
			local i0=i-1
			if i0<n then
				d.c.BackgroundTransparency=0 d.c.BackgroundColor3=C.ac d.s.Color=C.ac d.s.Transparency=0
				stx[i].TextColor3=C.tx stx[i].TextTransparency=0
			elseif i0==n then
				d.c.BackgroundTransparency=1 d.s.Color=C.ac d.s.Transparency=0
				stx[i].TextColor3=C.tx stx[i].TextTransparency=0
				pulses[i]=TweenService:Create(d.s,TweenInfo.new(0.7,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),{Transparency=0.8})
				pulses[i]:Play()
			else
				d.c.BackgroundTransparency=1 d.s.Color=C.mut d.s.Transparency=0.55
				stx[i].TextColor3=C.mut stx[i].TextTransparency=0.55
			end
		end
	end
	function T.setTitle(s) tt.Text=s end
	function T.alive() return e.Parent~=nil end
	function T.running()
		open=true bodyF.Visible=true chev.Rotation=270
		dotTw=TweenService:Create(dst,TweenInfo.new(0.7,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),{Transparency=0.8})
		dotTw:Play()
		T.step(0)
		tt.Text=t("thk")
	end
	function T.done(secs,text)
		if dotTw then dotTw:Cancel() dotTw=nil end
		dot.BackgroundTransparency=0 dot.BackgroundColor3=C.ac dst.Transparency=0
		tt.Text=t("thd").." "..math.max(1,secs or 1).."s"
		T.step(3)
		open=false bodyF.Visible=false chev.Rotation=90
		if text and text~="" then
			frame(bodyF,{Size=UDim2.new(1,0,0,1),BackgroundColor3=C.ln,LayoutOrder=1})
			local wEst=math.max(160,math.min(ui.vp.X,720)-28-32-24-8)
			local eh=TextService:GetTextSize(text,12,FONT,Vector2.new(wEst,100000)).Y
			local sc=new("ScrollingFrame",{BackgroundTransparency=1,BorderSizePixel=0,Size=UDim2.new(1,0,0,math.min(170,eh+6)),
				CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollBarThickness=3,ScrollBarImageColor3=C.ln,LayoutOrder=2},bodyF)
			lbl(sc,text,{size=12,color=C.mut,wrap=true,sz=UDim2.new(1,-6,0,0),auto=YA,ya=Enum.TextYAlignment.Top,lh=1.1})
		end
	end
	hh.Activated:Connect(function()
		open=not open
		bodyF.Visible=open
		chev.Rotation=open and 270 or 90
	end)
	if o then T.done(o.ts,o.th) else T.running() end
	return T
end
local function addMsg(r,x,o,anim,pendingBlock)
	local host=ui.msgs
	if r=="u" then
		local row=frame(host,{AutomaticSize=YA})
		new("UIListLayout",{HorizontalAlignment=Enum.HorizontalAlignment.Right,SortOrder=Enum.SortOrder.LayoutOrder},row)
		local b=lbl(row,x,{wrap=true,size=15,lh=1.1})
		b.BackgroundTransparency=0 b.BackgroundColor3=C.bg2
		corner(b,18) pad(b,16,10,16,10)
		new("UISizeConstraint",{MaxSize=Vector2.new(ui.maxBub,math.huge)},b)
		return {row=row,labels={}}
	end
	local row=frame(host,{AutomaticSize=YA})
	hlist(row,12,Enum.VerticalAlignment.Top)
	local lg=frame(row,{Size=UDim2.fromOffset(20,24)})
	Icon("logo",lg,20,C.ac,{pos=UDim2.fromOffset(0,2)})
	local w=frame(row,{Size=UDim2.new(1,-32,0,0),AutomaticSize=YA})
	vlist(w,0)
	local T=nil
	if pendingBlock then
		T=mkThink(w,nil)
	elseif o and o.ts~=nil then
		mkThink(w,o)
	end
	if T or (o and o.ts~=nil) then frame(w,{Size=UDim2.new(1,0,0,10),LayoutOrder=1}) end
	local labels={}
	if not pendingBlock then
		local body=frame(w,{AutomaticSize=YA,LayoutOrder=2})
		vlist(body,8)
		labels=rich(body,x)
		local act=frame(w,{Size=UDim2.new(1,0,0,34),LayoutOrder=3})
		local cp=btn(act,{Size=UDim2.fromOffset(30,30),Position=UDim2.new(0,0,0,4)})
		corner(cp,8)
		Icon("cp",cp,18,C.mut,{anchor=Vector2.new(0.5,0.5),pos=UDim2.new(0.5,0,0.5,0)})
		cp.Activated:Connect(function()
			local ok=false
			if setclipboard then ok=pcall(setclipboard,x) end
			toast(t(ok and "cpd" or "cpf"))
		end)
	end
	return {row=row,labels=labels,think=T}
end
local function typeReveal(items)
	local lens,total={},0
	for i,l in ipairs(items) do
		lens[i]=utf8.len(l.Text) or #l.Text
		total=total+lens[i]
		l.MaxVisibleGraphemes=0
	end
	task.spawn(function()
		local per=math.max(2,math.ceil(total/150))
		local shown=0
		while shown<total do
			shown=math.min(total,shown+per)
			local rem=shown
			for i,l in ipairs(items) do
				if l.Parent then l.MaxVisibleGraphemes=math.min(lens[i],math.max(0,rem)) end
				rem=rem-lens[i]
			end
			scrollBottom()
			task.wait(0.02)
		end
		for _,l in ipairs(items) do if l.Parent then l.MaxVisibleGraphemes=-1 end end
	end)
end
scrollBottom=function()
	task.delay(0.05,function()
		local m=ui.main
		if m and m.Parent then m.CanvasPosition=Vector2.new(0,math.max(0,m.AbsoluteCanvasSize.Y-m.AbsoluteSize.Y)) end
	end)
end
show=function()
	if not ui.wlWrap then return end
	local has=(cur and #cur.m>0) or soonMode
	ui.wlWrap.Visible=not has
end
renderMsgs=function(animLast)
	if not ui.msgs then return end
	for _,c in ipairs(ui.msgs:GetChildren()) do if c:IsA("GuiObject") then c:Destroy() end end
	if soonMode then
		addMsg("a",t("soon"))
	elseif cur then
		for i,m in ipairs(cur.m) do
			local res=addMsg(m.r,m.t,m)
			if animLast and i==#cur.m and m.r=="a" and #res.labels>0 then typeReveal(res.labels) end
		end
		if busy and pend and pend.chat==cur then
			local res=addMsg("a","",nil,false,true)
			local P=pend
			local T=res.think
			task.spawn(function()
				while pend==P and T.alive() do
					local s=math.max(1,os.time()-P.t0)
					T.setTitle(t("thk").." "..s.."s")
					if s>=5 then T.step(2) elseif s>=2 then T.step(1) end
					task.wait(0.5)
				end
			end)
		end
	end
	show()
	scrollBottom()
end
chipUpd=function()
	if not ui.chipN then return end
	ui.chipN.Text=(MD[S.cm+1] or MD[1]).n:gsub("Manos ","")
	ui.chipS.Text=t("e"..S.li)
end
greet=function()
	if not ui.gr then return end
	local h=tonumber(os.date("%H")) or 12
	local k=(h>=5 and h<13) and "gm" or ((h>=13 and h<18) and "ga" or "ge")
	ui.gr.Text=t(k)..(U and (", "..uname()) or "")
end
local function updSend()
	if not ui.sd then return end
	local off=busy or trim(ui.inp.Text)==""
	ui.sd.BackgroundTransparency=off and 0.55 or 0
end
refresh=function() show() sgs() end
local function refreshAll()
	greet() chipUpd() sgs() list() renderMsgs() updSend()
	if ui.av then ui.av.Text=U and cut(uname(),1):upper() or "" end
end
sgs=function()
	if not ui.sgsF then return end
	for _,c in ipairs(ui.sgsF:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
	if not S.sug then return end
	for i,k in ipairs({"s1","s2","s3"}) do
		local b=btn(ui.sgsF,{AutomaticSize=XYA,BackgroundTransparency=0,BackgroundColor3=C.bg2,LayoutOrder=i})
		pill(b) pad(b,16,9,16,9)
		lbl(b,t(k),{size=13,color=C.mut})
		b.Activated:Connect(function() ui.inp.Text=t(k) doSend() end)
	end
end
list=function()
	if not ui.list then return end
	for _,c in ipairs(ui.list:GetChildren()) do if c:IsA("GuiObject") then c:Destroy() end end
	if #chats==0 then
		lbl(ui.list,t("noc"),{size=13,color=C.mut})
		return
	end
	for i,c in ipairs(chats) do
		local b=btn(ui.list,{Size=UDim2.new(1,0,0,40),LayoutOrder=i})
		Icon("chat",b,20,C.tx,{pos=UDim2.new(0,4,0.5,-10)})
		lbl(b,c.title or "",{size=13.5,pos=UDim2.new(0,36,0.5,0),anchor=Vector2.new(0,0.5),sz=UDim2.new(1,-44,0,20),auto=Enum.AutomaticSize.None,trunc=Enum.TextTruncate.AtEnd})
		b.Activated:Connect(function() cur=c soonMode=false renderMsgs() menu(false) end)
	end
end
menu=function(o)
	if not ui.dr then return end
	ui.drOpen=o
	if o then ui.ov.Visible=true end
	TweenService:Create(ui.ov,TweenInfo.new(0.2),{BackgroundTransparency=o and 0.45 or 1}):Play()
	TweenService:Create(ui.dr,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=UDim2.new(0,o and 0 or -(ui.drW+10),0,0)}):Play()
	if not o then task.delay(0.26,function() if ui.ov and ui.ov.Parent and not ui.drOpen then ui.ov.Visible=false end end) end
end
fresh=function()
	cur=nil soonMode=false
	renderMsgs()
	menu(false)
	if ui.inp then ui.inp:CaptureFocus() end
end
openSet=function()
	menu(false)
	rset()
	ui.stb.CanvasPosition=Vector2.new(0,0)
	ui.st.Visible=true
end
doSend=function()
	local x=trim(ui.inp.Text)
	if x=="" or busy then return end
	if KEY=="" then keyp() return end
	if not cur then
		cur={title=cut(x,40),m={}}
		table.insert(chats,1,cur)
	end
	soonMode=false
	local ch=cur
	table.insert(ch.m,{r="u",t=x})
	ui.inp.Text=""
	busy=true
	local P={chat=ch,t0=os.time()}
	pend=P
	list() renderMsgs() updSend()
	ask(function(ans,reasoning,err)
		local m={r="a",t=""}
		local secs=math.max(1,os.time()-P.t0)
		if (ans==nil or ans=="") and err then
			m.t=err
		else
			m.t=ans or "..."
			m.th=cut(reasoning or "",8000)
			m.ts=secs
		end
		table.insert(ch.m,m)
		busy=false
		if pend==P then pend=nil end
		sv2() list()
		if cur==ch and not soonMode then renderMsgs(S.typ) end
		updSend()
		if S.speak then speak(m.t) end
		ntf(m.t)
	end)
end

----------------------------------------------------------------- chiamata
local callId=0
local function fmt(n) return string.format("%02d:%02d",math.floor(n/60),n%60) end
local pulseTw={}
local function setPulse(kind)
	for _,tw in ipairs(pulseTw) do pcall(function() tw:Cancel() end) end
	pulseTw={}
	if not ui.ring then return end
	if not kind then ui.ring.Visible=false return end
	local d=(kind=="l") and 1.8 or 0.9
	local o=ui.orbSize
	ui.ring.Visible=true
	ui.ring.Size=UDim2.fromOffset(o,o)
	ui.ringS.Transparency=0.55
	local info=TweenInfo.new(d,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,-1,false)
	local a=TweenService:Create(ui.ring,info,{Size=UDim2.fromOffset(o+80,o+80)})
	local b=TweenService:Create(ui.ringS,info,{Transparency=1})
	a:Play() b:Play()
	pulseTw={a,b}
end
local function cst(s,k)
	if not ui.cs then return end
	ui.cs.Text=s
	setPulse(k)
end
local function pushMsg(r,x)
	if not cur then
		cur={title=cut(x,40),m={}}
		table.insert(chats,1,cur)
	end
	soonMode=false
	table.insert(cur.m,{r=r,t=x})
	renderMsgs() sv2() list()
end
local function listenCall()
	if not cOn then return end
	cst(cMute and t("c5") or t("c2"),(not cMute) and "l" or nil)
end
local function handleCall(s)
	cBusy=true
	cst(t("c3"),nil)
	pushMsg("u",s)
	ask(function(ans,_,err)
		if not cOn then cBusy=false return end
		local a=ans or err or "..."
		pushMsg("a",a)
		cst(t("c4"),"s")
		speak(a,function() cBusy=false listenCall() end)
	end)
end
startCall=function()
	if KEY=="" then keyp() return end
	callId=callId+1
	local my=callId
	cOn=true cMute=false cBusy=true cT=0
	ui.cl.Visible=true
	ui.ct.Text="00:00"
	ui.muBg.BackgroundColor3=C.bg3
	cst(t("c1"),nil)
	task.spawn(function()
		while cOn and my==callId do
			task.wait(1)
			if cOn and my==callId and ui.ct and ui.ct.Parent then cT=cT+1 ui.ct.Text=fmt(cT) end
		end
	end)
	task.delay(0.9,function()
		if not cOn or my~=callId then return end
		cst(t("c4"),"s")
		speak(t("hello"),function() cBusy=false listenCall() end)
	end)
end
endCall=function()
	cOn=false
	callId=callId+1
	stopSpeak()
	setPulse(nil)
	if ui.cl then ui.cl.Visible=false end
end

----------------------------------------------------------------- auth: helper
local playerGui=LP:WaitForChild("PlayerGui")
local alive=true
local function er(s) if ui.er then ui.er.Text=s end end
local function bad(s)
	er(s)
	local c=ui.card
	if c then
		task.spawn(function()
			local base=c.Position
			for _,dx in ipairs({-8,8,-8,8,0}) do
				c.Position=UDim2.new(base.X.Scale,base.X.Offset+dx,base.Y.Scale,base.Y.Offset)
				task.wait(0.06)
			end
			c.Position=base
		end)
	end
end
local function setLoading(b)
	ui.goBusy=b
	if ui.spn then ui.spn.Visible=b end
end
setTab=function(m,keep)
	AM=m
	if not ui.seg then return end
	TweenService:Create(ui.segI,TweenInfo.new(0.3,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Position=UDim2.new(m==1 and 0.5 or 0,m==1 and 0 or 3,0,3)}):Play()
	TweenService:Create(ui.fnw,TweenInfo.new(0.3),{Size=UDim2.new(1,0,0,m==1 and 56 or 0)}):Play()
	ui.gt.Text=t(m==1 and "signup" or "login")
	if not keep then er("") end
end
local function refreshAll()
	greet() chipUpd() sgs() list() renderMsgs() updSend()
	if ui.av then ui.av.Text=U and cut(uname(),1):upper() or "" end
end
enter=function(u,instant)
	U=u
	dbSet("session",{e=u.g and "~guest" or u.email})
	chats={} cur=nil soonMode=false
	local c=dbGet(ckey(),{})
	if type(c)=="table" then chats=c end
	T0=os.time()
	setLoading(false)
	if ui.au then
		if instant then ui.au.Visible=false
		else
			TweenService:Create(ui.au,TweenInfo.new(0.45),{GroupTransparency=1}):Play()
			task.delay(0.46,function() if U and ui.au and ui.au.Parent then ui.au.Visible=false end end)
		end
	end
	refreshAll()
	if KEY=="" and not instant then
		task.delay(0.7,function() if U then keyp() end end)
	end
end
logout=function()
	dbDel("session")
	U=nil
	endCall() closeSh() menu(false)
	if ui.st then ui.st.Visible=false end
	if ui.fp then ui.fp.Text="" end
	er("")
	if ui.au then
		ui.au.GroupTransparency=1
		ui.au.Visible=true
		TweenService:Create(ui.au,TweenInfo.new(0.3),{GroupTransparency=0}):Play()
	end
	refreshAll()
	toast(t("loggedOut"))
end
local function goClick()
	if ui.goBusy then return end
	local e=trim(ui.fe.Text):lower()
	local p=ui.fp.Text
	local n=trim(ui.fn.Text)
	if e=="" or p=="" or (AM==1 and n=="") then bad(t("eFill")) return end
	if not e:match("^[^@%s]+@[^@%s]+%.[^@%s]+$") then bad(t("eMail")) return end
	if AM==1 and #p<6 then bad(t("ePw")) return end
	if AM==1 and users[e] then bad(t("eEx")) return end
	er("")
	setLoading(true)
	task.spawn(function()
		local h=sha256("manos:"..p)
		task.wait(0.65)
		if AM==1 then
			users[e]={name=n,pw=h}
			dbSet("users",users)
			enter({email=e,name=n})
		else
			local u=users[e]
			if not u or u.pw~=h then setLoading(false) bad(t("eBad")) return end
			enter({email=e,name=u.name})
		end
	end)
end

----------------------------------------------------------------- costruzione interfaccia
local function build()
	local savedMsg=ui.inp and ui.inp.Text or ""
	local savedE,savedP,savedN=ui.fe and ui.fe.Text or "",ui.fp and ui.fp.Text or "",ui.fn and ui.fn.Text or ""
	if ui.gui then pcall(function() ui.gui:Destroy() end) end
	applyTheme()
	for k in pairs(ui) do ui[k]=nil end
	local cam=workspace.CurrentCamera
	local vp=cam and cam.ViewportSize or Vector2.new(800,400)
	local inset=0
	pcall(function() inset=GuiService:GetGuiInset().Y end)
	local topPad=math.max(inset,40)
	local HDRT=topPad+44
	local colW=math.min(vp.X,720)
	ui.vp=vp ui.topPad=topPad ui.colW=colW
	ui.maxBub=math.max(160,math.floor(colW*0.86)-32)
	ui.pnW=math.min(vp.X,560)
	local full=UDim2.fromScale(1,1)
	local V2=Vector2.new

	local gui=new("ScreenGui",{Name="ManosAI",ResetOnSpawn=false,IgnoreGuiInset=true,DisplayOrder=99999,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},playerGui)
	pcall(function() gui.ScreenInsets=Enum.ScreenInsets.None end)
	ui.gui=gui
	local root=frame(gui,{Size=full,BackgroundTransparency=0,BackgroundColor3=C.bg})
	root.Active=true
	ui.root=root

	-- colonna principale
	local col=frame(root,{AnchorPoint=V2(0.5,0),Position=UDim2.new(0.5,0,0,0),Size=full})
	new("UISizeConstraint",{MaxSize=V2(720,math.huge)},col)
	local mn=btn(col,{Size=UDim2.fromOffset(36,36),Position=UDim2.fromOffset(8,topPad+4)})
	Icon("menu",mn,22,C.tx,{anchor=V2(0.5,0.5),pos=UDim2.new(0.5,0,0.5,0)})
	local gh=btn(col,{Size=UDim2.fromOffset(40,40),AnchorPoint=V2(1,0),Position=UDim2.new(1,-8,0,topPad+2)})
	Icon("ghost",gh,26,C.tx,{anchor=V2(0.5,0.5),pos=UDim2.new(0.5,0,0.5,0)})

	local main=new("ScrollingFrame",{BackgroundTransparency=1,BorderSizePixel=0,Position=UDim2.new(0,0,0,HDRT),Size=UDim2.new(1,0,1,-(HDRT+130)),
		ScrollBarThickness=3,ScrollBarImageColor3=C.ln,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollingDirection=Enum.ScrollingDirection.Y},col)
	pad(main,14,0,14,0) vlist(main,0)
	ui.main=main
	local wlWrap=frame(main,{Size=UDim2.new(1,0,0,200),LayoutOrder=0})
	local wlIn=frame(wlWrap,{AnchorPoint=V2(0.5,0.5),Position=UDim2.new(0.5,0,0.5,-10),AutomaticSize=YA})
	vlist(wlIn,8,Enum.HorizontalAlignment.Center)
	Icon("logo",wlIn,40,C.ac,{order=0})
	ui.gr=lbl(wlIn,"",{font=FONTH,size=23,wrap=true,sz=UDim2.new(1,0,0,0),auto=YA,xa=Enum.TextXAlignment.Center,order=1})
	local plan=frame(wlIn,{AutomaticSize=XYA,Size=UDim2.new(0,0,0,0),BackgroundTransparency=0,BackgroundColor3=C.bg2,LayoutOrder=2})
	pill(plan) pad(plan,18,8,18,8) hlist(plan,0)
	lbl(plan,t("plan"),{size=13,color=C.mut,order=0})
	local up=btn(plan,{AutomaticSize=XYA,LayoutOrder=1})
	lbl(up,t("upg"),{size=13,font=FONTB})
	up.Activated:Connect(function() planp() end)
	local sgsF=frame(wlIn,{AutomaticSize=YA,LayoutOrder=3})
	new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Wraps=true,Padding=UDim.new(0,8),HorizontalAlignment=Enum.HorizontalAlignment.Center,SortOrder=Enum.SortOrder.LayoutOrder},sgsF)
	ui.sgsF=sgsF ui.wlWrap=wlWrap
	local msgs=frame(main,{AutomaticSize=YA,LayoutOrder=1})
	pad(msgs,0,8,0,20) vlist(msgs,22)
	ui.msgs=msgs
	local function centerWelcome()
		if wlWrap.Parent then wlWrap.Size=UDim2.new(1,0,0,math.max(wlIn.AbsoluteSize.Y+30,main.AbsoluteSize.Y)) end
	end
	wlIn:GetPropertyChangedSignal("AbsoluteSize"):Connect(centerWelcome)
	main:GetPropertyChangedSignal("AbsoluteSize"):Connect(centerWelcome)

	-- compositore
	local comp=frame(col,{AnchorPoint=V2(0,1),Position=UDim2.new(0,10,1,-10),Size=UDim2.new(1,-20,0,0),AutomaticSize=YA,BackgroundTransparency=0,BackgroundColor3=C.bg2})
	corner(comp,20) stroke(comp,C.ln,1) pad(comp,10,10,10,8) vlist(comp,6)
	local inp=new("TextBox",{BackgroundTransparency=1,BorderSizePixel=0,Size=UDim2.new(1,0,0,26),ClearTextOnFocus=false,MultiLine=true,TextWrapped=true,
		Text=savedMsg,PlaceholderText=t("ph"),PlaceholderColor3=C.mut,TextColor3=C.tx,Font=FONT,TextSize=16,
		TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,LayoutOrder=0},comp)
	ui.inp=inp
	local row=frame(comp,{Size=UDim2.new(1,0,0,34),LayoutOrder=1})
	local left=frame(row,{Size=UDim2.new(0,0,1,0),AutomaticSize=XA})
	hlist(left,8)
	local function rbtn(parent,name,bg,ic,order)
		local b=btn(parent,{Size=UDim2.fromOffset(34,34),BackgroundTransparency=0,BackgroundColor3=bg,LayoutOrder=order})
		pill(b)
		Icon(name,b,18,ic,{anchor=V2(0.5,0.5),pos=UDim2.new(0.5,0,0.5,0)})
		return b
	end
	local pl=rbtn(left,"plus",C.bg3,C.tx,0)
	local chip=btn(left,{Size=UDim2.new(0,0,0,34),AutomaticSize=XA,BackgroundTransparency=0,BackgroundColor3=C.bg3,LayoutOrder=1})
	pill(chip) pad(chip,14,0,14,0) hlist(chip,6)
	ui.chipN=lbl(chip,"",{size=13,order=0})
	ui.chipS=lbl(chip,"",{size=13,color=C.mut,order=1})
	local right=frame(row,{Size=UDim2.new(0,0,1,0),AutomaticSize=XA,AnchorPoint=V2(1,0),Position=UDim2.new(1,0,0,0)})
	hlist(right,8)
	local mc=rbtn(right,"mic",C.bg3,C.tx,0)
	local ca=rbtn(right,"phone",C.bg3,C.tx,1)
	local sd=rbtn(right,"up",C.ac,Color3.new(1,1,1),2)
	ui.sd=sd ui.mc=mc
	local function fit()
		if not inp.Parent then return end
		inp.Size=UDim2.new(1,0,0,math.clamp(inp.TextBounds.Y+4,26,120))
	end
	inp:GetPropertyChangedSignal("Text"):Connect(function() task.defer(fit) updSend() end)
	inp.Focused:Connect(function() mc.BackgroundColor3=C.ac end)
	inp.FocusLost:Connect(function() mc.BackgroundColor3=C.bg3 end)
	local function layoutMain()
		main.Size=UDim2.new(1,0,1,-(HDRT+comp.AbsoluteSize.Y+20))
	end
	comp:GetPropertyChangedSignal("AbsoluteSize"):Connect(layoutMain)
	pl.Activated:Connect(function() addp() end)
	chip.Activated:Connect(function() models() end)
	mc.Activated:Connect(function()
		if inp:IsFocused() then inp:ReleaseFocus()
		else toast(t("micKb")) inp:CaptureFocus() end
	end)
	ca.Activated:Connect(function() startCall() end)
	sd.Activated:Connect(function() doSend() end)
	mn.Activated:Connect(function() menu(true) end)
	gh.Activated:Connect(function() fresh() end)

	-- cassetto laterale
	local drW=math.min(300,vp.X*0.8)
	ui.drW=drW
	local ov=btn(root,{Size=full,BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,Visible=false,ZIndex=5})
	ui.ov=ov
	local dr=frame(root,{Size=UDim2.new(0,drW,1,0),Position=UDim2.new(0,-(drW+10),0,0),BackgroundTransparency=0,BackgroundColor3=C.bg,ZIndex=6})
	dr.Active=true
	frame(dr,{Size=UDim2.new(0,1,1,0),AnchorPoint=V2(1,0),Position=UDim2.new(1,0,0,0),BackgroundColor3=C.ln})
	ui.dr=dr
	local drBody=new("ScrollingFrame",{BackgroundTransparency=1,BorderSizePixel=0,Size=UDim2.new(1,0,1,-70),CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,
		ScrollBarThickness=3,ScrollBarImageColor3=C.ln},dr)
	pad(drBody,16,topPad+6,16,10) vlist(drBody,0)
	lbl(drBody,"Manos AI",{font=FONTH,size=24,order=0})
	frame(drBody,{Size=UDim2.new(1,0,0,14),LayoutOrder=1})
	local navs={{"chat","chat"},{"pj","proj"},{"code","code"},{"art","art"}}
	for i,nv in ipairs(navs) do
		local b=btn(drBody,{Size=UDim2.new(1,0,0,42),LayoutOrder=1+i})
		Icon(nv[1],b,20,C.tx,{pos=UDim2.new(0,2,0.5,-10)})
		lbl(b,t(nv[2]),{size=15,pos=UDim2.new(0,34,0.5,0),anchor=V2(0,0.5)})
		b.Activated:Connect(function()
			menu(false)
			if i>1 then cur=nil soonMode=true renderMsgs() end
		end)
	end
	frame(drBody,{Size=UDim2.new(1,0,0,1),BackgroundColor3=C.ln,LayoutOrder=10})
	local rl=lbl(drBody,t("rec"),{size=13,color=C.mut,order=11})
	frame(drBody,{Size=UDim2.new(1,0,0,6),LayoutOrder=12})
	local lst=frame(drBody,{AutomaticSize=YA,LayoutOrder=13})
	vlist(lst,2)
	ui.list=lst
	local bar=frame(dr,{Size=UDim2.new(1,0,0,70),AnchorPoint=V2(0,1),Position=UDim2.new(0,0,1,0)})
	local av=btn(bar,{Size=UDim2.fromOffset(38,38),AnchorPoint=V2(0,0.5),Position=UDim2.new(0,16,0.5,0),BackgroundTransparency=0,BackgroundColor3=C.ac,Text="",Font=FONTB,TextSize=14,TextColor3=Color3.new(1,1,1)})
	pill(av)
	ui.av=av
	local nw=btn(bar,{AutomaticSize=XYA,AnchorPoint=V2(1,0.5),Position=UDim2.new(1,-16,0.5,0),BackgroundTransparency=0,BackgroundColor3=C.inv})
	pill(nw) pad(nw,18,10,18,10) hlist(nw,6)
	Icon("plus",nw,14,C.invt,{order=0})
	lbl(nw,t("newc"),{size=14,color=C.invt,font=FONTM,order=1})
	ov.Activated:Connect(function() menu(false) end)
	nw.Activated:Connect(function() fresh() end)
	av.Activated:Connect(function() openSet() end)

	-- impostazioni
	local st=frame(root,{Size=full,BackgroundTransparency=0,BackgroundColor3=C.bg,ZIndex=11,Visible=false})
	st.Active=true
	ui.st=st
	local stCol=frame(st,{AnchorPoint=V2(0.5,0),Position=UDim2.new(0.5,0,0,0),Size=full})
	new("UISizeConstraint",{MaxSize=V2(720,math.huge)},stCol)
	local sx=btn(stCol,{Size=UDim2.fromOffset(36,36),Position=UDim2.fromOffset(8,topPad+4)})
	Icon("menu",sx,22,C.tx,{anchor=V2(0.5,0.5),pos=UDim2.new(0.5,0,0.5,0)})
	lbl(stCol,t("sTt"),{font=FONTH,size=20,anchor=V2(0.5,0.5),pos=UDim2.new(0.5,0,0,topPad+22)})
	local si=btn(stCol,{Size=UDim2.fromOffset(40,40),AnchorPoint=V2(1,0),Position=UDim2.new(1,-8,0,topPad+2)})
	Icon("info",si,24,C.tx,{anchor=V2(0.5,0.5),pos=UDim2.new(0.5,0,0.5,0)})
	local stb=new("ScrollingFrame",{BackgroundTransparency=1,BorderSizePixel=0,Position=UDim2.new(0,0,0,HDRT),Size=UDim2.new(1,0,1,-HDRT),
		CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollBarThickness=3,ScrollBarImageColor3=C.ln},stCol)
	ui.stb=stb
	sx.Activated:Connect(function() st.Visible=false end)
	si.Activated:Connect(function() aboutp() end)

	-- chiamata
	local cl=frame(root,{Size=full,BackgroundTransparency=0,BackgroundColor3=C.bg,ZIndex=10,Visible=false})
	cl.Active=true
	ui.cl=cl
	lbl(cl,"Manos AI",{font=FONTH,size=26,anchor=V2(0.5,0),pos=UDim2.new(0.5,0,0,topPad+8)})
	ui.ct=lbl(cl,"00:00",{size=14,color=C.mut,anchor=V2(0.5,0),pos=UDim2.new(0.5,0,0,topPad+44)})
	local osz=(vp.Y<500) and 84 or 120
	ui.orbSize=osz
	local ring=frame(cl,{Size=UDim2.fromOffset(osz,osz),AnchorPoint=V2(0.5,0.5),Position=UDim2.new(0.5,0,0.48,0),Visible=false})
	pill(ring)
	ui.ring=ring ui.ringS=stroke(ring,C.ac,2,0.55)
	local orb=frame(cl,{Size=UDim2.fromOffset(osz,osz),AnchorPoint=V2(0.5,0.5),Position=UDim2.new(0.5,0,0.48,0),BackgroundTransparency=0,BackgroundColor3=C.bg2,ZIndex=2})
	pill(orb)
	Icon("logo",orb,osz*0.43,C.ac,{anchor=V2(0.5,0.5),pos=UDim2.new(0.5,0,0.5,0)})
	ui.cs=lbl(cl,"",{size=14,color=C.mut,anchor=V2(0.5,0),pos=UDim2.new(0.5,0,0.48,osz/2+12)})
	local crow=frame(cl,{Size=UDim2.new(1,-40,0,54),AnchorPoint=V2(0.5,1),Position=UDim2.new(0.5,0,1,-24)})
	new("UISizeConstraint",{MaxSize=V2(560,54)},crow)
	local muBg=btn(crow,{Size=UDim2.fromOffset(54,54),BackgroundTransparency=0,BackgroundColor3=C.bg3})
	pill(muBg)
	local muIc=frame(muBg,{Size=UDim2.fromOffset(26,26),AnchorPoint=V2(0.5,0.5),Position=UDim2.new(0.5,0,0.5,0)})
	Icon("mic",muIc,26,C.tx)
	ui.muBg=muBg
	local en=btn(crow,{Size=UDim2.fromOffset(54,54),AnchorPoint=V2(1,0),Position=UDim2.new(1,0,0,0),BackgroundTransparency=0,BackgroundColor3=Color3.fromHex("d6453d")})
	pill(en)
	Icon("phone",en,28,Color3.new(1,1,1),{anchor=V2(0.5,0.5),pos=UDim2.new(0.5,0,0.5,0),rot=135,th=2})
	local cbx=frame(crow,{Position=UDim2.new(0,64,0,4),Size=UDim2.new(1,-128,0,46),BackgroundTransparency=0,BackgroundColor3=C.bg2})
	pill(cbx)
	local cin=new("TextBox",{BackgroundTransparency=1,BorderSizePixel=0,Position=UDim2.new(0,16,0,0),Size=UDim2.new(1,-32,1,0),ClearTextOnFocus=false,Text="",
		PlaceholderText=t("callPh"),PlaceholderColor3=C.mut,TextColor3=C.tx,Font=FONT,TextSize=15,TextXAlignment=Enum.TextXAlignment.Left,ClipsDescendants=true},cbx)
	ui.cin=cin
	cin.FocusLost:Connect(function(enterPressed)
		if not enterPressed or not cOn or cMute or cBusy then return end
		local x=trim(cin.Text)
		if x=="" then return end
		cin.Text=""
		handleCall(x)
	end)
	muBg.Activated:Connect(function()
		cMute=not cMute
		muBg.BackgroundColor3=cMute and C.inv or C.bg3
		for _,c in ipairs(muIc:GetChildren()) do c:Destroy() end
		Icon("mic",muIc,26,cMute and C.invt or C.tx)
		if cMute then cst(t("c5"),nil) elseif not cBusy then listenCall() end
	end)
	en.Activated:Connect(function() endCall() end)

	-- foglio inferiore
	local sheet=frame(root,{Size=full,ZIndex=12,Visible=false})
	ui.sheet=sheet
	local bk=btn(sheet,{Size=full,BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.45})
	local pn=frame(sheet,{AnchorPoint=V2(0.5,1),Position=UDim2.new(0.5,0,1,24),Size=UDim2.new(0,ui.pnW,0,360),BackgroundTransparency=0,BackgroundColor3=C.bg})
	pn.Active=true
	corner(pn,22)
	ui.pn=pn
	local pnClose=btn(pn,{Size=UDim2.fromOffset(40,40),Position=UDim2.fromOffset(8,8)})
	ui.pnClose=pnClose
	ui.pnTitle=lbl(pn,"",{size=16,font=FONTB,anchor=V2(0.5,0.5),pos=UDim2.new(0.5,0,0,28)})
	local pnBody=new("ScrollingFrame",{BackgroundTransparency=1,BorderSizePixel=0,Position=UDim2.new(0,0,0,56),Size=UDim2.new(1,0,1,-80),
		CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollBarThickness=3,ScrollBarImageColor3=C.ln},pn)
	ui.pnBody=pnBody
	bk.Activated:Connect(function() closeSh() end)
	pnClose.Activated:Connect(function()
		if CP and CP.back then CP.back() else closeSh() end
	end)

	-- toast
	local ttp=frame(root,{AnchorPoint=V2(0.5,1),Position=UDim2.new(0.5,0,1,-120),Size=UDim2.new(0,0,0,0),AutomaticSize=XYA,BackgroundTransparency=0,BackgroundColor3=C.inv,ZIndex=30,Visible=false})
	corner(ttp,18) pad(ttp,16,9,16,9)
	ui.ttp=ttp
	ui.tt=lbl(ttp,"",{size=13,color=C.invt,wrap=true,xa=Enum.TextXAlignment.Center})
	new("UISizeConstraint",{MaxSize=V2(math.max(120,vp.X*0.88-32),math.huge)},ui.tt)

	-- accesso
	local au=new("CanvasGroup",{Size=full,BackgroundColor3=C.bg,BorderSizePixel=0,ZIndex=20,Visible=(U==nil),GroupTransparency=0,Active=true},root)
	ui.au=au
	local function orbF(sz,color,pos,anch)
		local o=frame(au,{Size=UDim2.fromOffset(sz,sz),BackgroundColor3=color,BackgroundTransparency=0.82,Position=pos,AnchorPoint=anch})
		pill(o)
		return o
	end
	local o1=orbF(260,Color3.fromHex("d9775a"),UDim2.new(0,-70,0,-60),V2(0,0))
	local o2=orbF(240,Color3.fromHex("6a5cff"),UDim2.new(1,60,1,70),V2(1,1))
	TweenService:Create(o1,TweenInfo.new(14,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),{Position=UDim2.new(0,-20,0,-20)}):Play()
	TweenService:Create(o2,TweenInfo.new(14,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),{Position=UDim2.new(1,10,1,20)}):Play()
	local sc=new("ScrollingFrame",{BackgroundTransparency=1,BorderSizePixel=0,Size=full,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollBarThickness=0},au)
	local cardW=math.min(340,vp.X-40)
	local card=frame(sc,{AnchorPoint=V2(0.5,0),Position=UDim2.new(0.5,0,0,topPad+30),Size=UDim2.new(0,cardW,0,0),AutomaticSize=YA})
	vlist(card,0,Enum.HorizontalAlignment.Center)
	ui.card=card
	local function layoutAuth()
		if not card.Parent then return end
		local top=math.max(topPad+20,(vp.Y-card.AbsoluteSize.Y)/2)
		card.Position=UDim2.new(0.5,0,0,top)
	end
	card:GetPropertyChangedSignal("AbsoluteSize"):Connect(layoutAuth)
	local function sp(order,h) return frame(card,{Size=UDim2.new(1,0,0,h),LayoutOrder=order}) end
	-- IT/EN
	local lgs=frame(au,{AutomaticSize=XYA,Size=UDim2.new(0,0,0,0),AnchorPoint=V2(1,0),Position=UDim2.new(1,-14,0,topPad),BackgroundTransparency=0,BackgroundColor3=C.bg2,ZIndex=3})
	pill(lgs) pad(lgs,3,3,3,3) hlist(lgs,0)
	for i,nm in ipairs({"IT","EN"}) do
		local b=btn(lgs,{AutomaticSize=XYA,BackgroundTransparency=((L==i-1) and 0 or 1),BackgroundColor3=C.ac,LayoutOrder=i})
		pill(b) pad(b,12,5,12,5)
		lbl(b,nm,{size=13,color=(L==i-1) and Color3.new(1,1,1) or C.mut})
		b.Activated:Connect(function() rebuild(i-1) end)
	end
	Icon("logo",card,56,C.ac,{order=1})
	lbl(card,"Manos AI",{font=FONTH,size=29,order=2})
	local sub=lbl(card,t("tag"),{size=14,color=C.mut,order=3,sz=UDim2.new(1,0,0,0),auto=YA,wrap=true,xa=Enum.TextXAlignment.Center})
	sp(4,18)
	local seg=frame(card,{Size=UDim2.new(1,0,0,42),BackgroundTransparency=0,BackgroundColor3=C.bg2,LayoutOrder=5})
	pill(seg)
	local segI=frame(seg,{Size=UDim2.new(0.5,-3,1,-6),Position=UDim2.new(AM==1 and 0.5 or 0,AM==1 and 0 or 3,0,3),BackgroundTransparency=0,BackgroundColor3=C.bg3})
	pill(segI)
	ui.seg=seg ui.segI=segI
	for i,k in ipairs({"login","signup"}) do
		local b=btn(seg,{Size=UDim2.new(0.5,0,1,0),Position=UDim2.new((i-1)*0.5,0,0,0),ZIndex=2})
		lbl(b,t(k),{size=14,anchor=V2(0.5,0.5),pos=UDim2.new(0.5,0,0.5,0),z=3})
		b.Activated:Connect(function() setTab(i-1) end)
	end
	sp(6,14)
	local function fieldBox(parent,ph,pw,order)
		local wrap=frame(parent,{Size=UDim2.new(1,0,0,56),LayoutOrder=order})
		local bx=frame(wrap,{Size=UDim2.new(1,0,0,46),BackgroundTransparency=0,BackgroundColor3=C.bg2})
		corner(bx,14)
		local sk=stroke(bx,C.ln,1)
		local tb,_,api=mkInput(bx,{ph=ph,pw=pw,pr=(pw and 46 or 14),size=15})
		tb.Focused:Connect(function() sk.Color=C.ac end)
		tb.FocusLost:Connect(function() sk.Color=C.ln end)
		if pw then
			local eb=btn(bx,{Size=UDim2.fromOffset(36,36),AnchorPoint=V2(1,0.5),Position=UDim2.new(1,-6,0.5,0),ZIndex=3})
			local holder=frame(eb,{Size=UDim2.fromOffset(20,20),AnchorPoint=V2(0.5,0.5),Position=UDim2.new(0.5,0,0.5,0)})
			local function draw(masked)
				for _,c in ipairs(holder:GetChildren()) do c:Destroy() end
				Icon(masked and "eye" or "eyeoff",holder,20,C.mut)
			end
			draw(true)
			eb.Activated:Connect(function() draw(api.toggle()) end)
		end
		return tb,wrap
	end
	local fnw=frame(card,{Size=UDim2.new(1,0,0,AM==1 and 56 or 0),LayoutOrder=7})
	fnw.ClipsDescendants=true
	ui.fnw=fnw
	ui.fn=fieldBox(fnw,t("name"),false,0)
	ui.fe=fieldBox(card,t("email"),false,8)
	ui.fp=fieldBox(card,t("pass"),true,9)
	ui.fe.Text=savedE ui.fp.Text=savedP ui.fn.Text=savedN
	ui.er=lbl(card,"",{size=13,color=Color3.fromHex("e0706a"),wrap=true,sz=UDim2.new(1,0,0,20),auto=YA,order=10})
	sp(11,6)
	local go=btn(card,{Size=UDim2.new(1,0,0,46),BackgroundTransparency=0,BackgroundColor3=C.ac,LayoutOrder=12})
	corner(go,14)
	local gcon=frame(go,{AnchorPoint=V2(0.5,0.5),Position=UDim2.new(0.5,0,0.5,0),AutomaticSize=XYA,Size=UDim2.new(0,0,0,0)})
	hlist(gcon,8)
	ui.gt=lbl(gcon,t(AM==1 and "signup" or "login"),{size=15,font=FONTB,color=Color3.new(1,1,1),order=0})
	local spn=frame(gcon,{Size=UDim2.fromOffset(16,16),LayoutOrder=1,Visible=false})
	local rg=frame(spn,{Size=full})
	pill(rg) stroke(rg,Color3.new(1,1,1),2,0.6)
	local dt=frame(spn,{Size=UDim2.fromOffset(4,4),AnchorPoint=V2(0.5,0),Position=UDim2.new(0.5,0,0,-1),BackgroundTransparency=0,BackgroundColor3=Color3.new(1,1,1)})
	pill(dt)
	TweenService:Create(spn,TweenInfo.new(0.7,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,-1,false),{Rotation=360}):Play()
	ui.spn=spn
	go.Activated:Connect(goClick)
	sp(13,14)
	local gu=btn(card,{AutomaticSize=XYA,LayoutOrder=14})
	lbl(gu,"<u>"..t("guest").."</u>",{size=13.5,color=C.mut,rt=true})
	gu.Activated:Connect(function() enter({email="~guest",name="",g=true}) end)
	ui.fp.FocusLost:Connect(function(ep) if ep then goClick() end end)

	task.defer(function() layoutMain() fit() centerWelcome() layoutAuth() end)
end

rebuild=function(lang)
	if lang~=nil then L=lang S.lang=lang sv() end
	local wasSet=stOn()
	local wasCP=CP
	local wasCall=cOn
	build()
	refreshAll()
	if U and wasSet then rset() ui.st.Visible=true end
	if wasCP then rs() end
	if wasCall then
		ui.cl.Visible=true
		ui.ct.Text=fmt(cT)
		cst(cBusy and t("c3") or t("c2"),(not cBusy) and "l" or nil)
	end
end

----------------------------------------------------------------- avvio
build()
do
	local sid=dbGet("session",nil)
	if type(sid)=="table" and type(sid.e)=="string" then
		if sid.e=="~guest" then enter({email="~guest",name="",g=true},true)
		elseif type(users[sid.e])=="table" then enter({email=sid.e,name=users[sid.e].name},true) end
	end
end
if not U then refreshAll() end

task.spawn(function()
	while alive do
		task.wait(30)
		if S.brk and S.brk>0 and os.time()-T0>=S.brk*60 then
			T0=os.time()
			toast(t("brkMsg"))
		end
	end
end)

local camConn=nil
do
	local lastVP=ui.vp
	local debounce=0
	local function hook()
		local cam=workspace.CurrentCamera
		if not cam then return end
		camConn=cam:GetPropertyChangedSignal("ViewportSize"):Connect(function()
			debounce=debounce+1
			local my=debounce
			task.delay(0.5,function()
				if my~=debounce or not alive then return end
				local nv=workspace.CurrentCamera.ViewportSize
				if lastVP and (math.abs(nv.X-lastVP.X)>30 or math.abs(nv.Y-lastVP.Y)>30) then
					lastVP=nv
					rebuild()
				end
			end)
		end)
	end
	hook()
end

genv.ManosAI_Destroy=function()
	alive=false
	cOn=false
	pcall(stopSpeak)
	if camConn then pcall(function() camConn:Disconnect() end) end
	if ui.gui then pcall(function() ui.gui:Destroy() end) end
end
