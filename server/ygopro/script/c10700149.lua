phi=phi or {}

local m=10700149
phi.diffcultnum={}
function Card.GetPhiDif(c,dif)
    if not c:IsSetCard(0x77d) then return false end
    local i=dif
    if Auxiliary.GetValueType(dif)=="string" then
        if dif=="ez" then i=1 end
        if dif=="md" then i=2 end
        if dif=="hd" then i=3 end
        if dif=="at" then i=4 end
        if dif=="sp" then i=5 end
        if dif=="le" then i=6 end
    end
    local num=c:GetCode()
    return phi.diffcultnum[num][1][i]
end

function phi.power(k,ez,md,hd,at,sp,le,type,atk,def,level,race,att)
    phi.diffcultnum[k]={{ez,md,hd,at,sp,le},{type,atk,def,level,race,att}}
end

function Card.GetPhi(c,inf)
    if not c:IsSetCard(0x77d) then return false end
    if c:IsType(TYPE_MONSTER) then
        if inf=="type" then return c:GetType() end
        if inf=="atk" then return c:GetAttack() end
        if inf=="def" then return c:GetDefense() end
        if inf=="level" then return c:GetLevel() end
        if inf=="race" then return c:GetRace() end
        if inf=="att" then return c:GetAttribute() end
    else
        local i
        if inf=="type" then i=1 end
        if inf=="atk" then i=2 end
        if inf=="def" then i=3 end
        if inf=="level" then i=4 end
        if inf=="race" then i=5 end
        if inf=="att" then i=6 end
        local num=c:GetCode()
        return phi.diffcultnum[num][2][i]
    end
end

function Card.IsExistsPhi(c,lv)
    local num=c:GetCode()
    for k,v in ipairs(phi.diffcultnum[num][1]) do
        if v==lv then return true end
    end
    return false
end

function Card.CheckPhi(c,type)
    if not c:IsSetCard(0x77d) then return false end
    local num=c:GetCode()
    if type==TYPE_MONSTER then
        return phi.diffcultnum[num][2][4]==0
    else
        return bit.band(phi.diffcultnum[num][2][4],type)~=0
    end
end

function Card.GetPhiType(c,type)
    if not c:IsSetCard(0x77d) then return false end
    local num=c:GetCode()
    return phi.diffcultnum[num][2][4]==type
end

function Card.PhiSpecialSummonCheck(c,e,tp,sumtype,pos,rp)
    if not c:IsSetCard(0x77d) then return false end
    if sumtype==nil then sumtype=0 end
    if pos==nil then pos=POS_FACEUP end
    if rp==nil then rp=tp end
    if c:IsType(TYPE_MONSTER) then
        return c:IsCanBeSpecialSummoned(e,sumtype,tp,false,false,pos,rp)
    else
        return Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0x77d,c:GetPhi("type"),c:GetPhi("atk"),c:GetPhi("def"),c:GetFlagEffectLabel(m),c:GetPhi("race"),c:GetPhi("att"),pos,rp) and c:IsCanBeSpecialSummoned(e,sumtype,tp,true,true,pos,rp)
    end
end

function Duel.PhiSpecialSummon(tg,sumtype,sp,tp,nocheck,nolimit,pos,zone)
    if zone==nil then zone=0xff end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
    local ck=0
    if Auxiliary.GetValueType(tg)=="Group" then
        if Duel.GetLocationCount(tp,LOCATION_MZONE)<#tg then tg=tg:Select(sp,Duel.GetLocationCount(tp,LOCATION_MZONE),Duel.GetLocationCount(tp,LOCATION_MZONE),nil) end
        if #tg>0 then
            local tc=tg:GetFirst()
            while tc do
                if tc:IsType(TYPE_MONSTER) then
                    Duel.SpecialSummonStep(tc,sumtype,sp,tp,nocheck,nolimit,pos,zone)
                else
                    if Duel.SpecialSummonStep(tc,sumtype,sp,tp,true,nolimit,pos,zone) then
                        tc:PhiAddData()
                    end
                end
                tc=tg:GetNext()
            end
            if Duel.SpecialSummonComplete() then ck=1 end
        end
    end
    if Auxiliary.GetValueType(tg)=="Card" then
        if tg:IsType(TYPE_SPELL+TYPE_TRAP) and Duel.SpecialSummonStep(tg,sumtype,sp,tp,true,nolimit,pos,zone) then
            tg:PhiAddData()
            if Duel.SpecialSummonComplete() then ck=1 end
        elseif Duel.SpecialSummon(tg,sumtype,sp,tp,nocheck,nolimit,pos,zone) then
            ck=1
        end
    end
    if ck==1 then return true else return false end
end

function Card.SetLevel(rc,dif,sc)
    if dif==nil then return false end
    if sc==nil then sc=rc end
    local lv=dif
    if Auxiliary.GetValueType(dif)=="string" then
        lv=rc:GetPhiDif(dif)
    end
    local e1=Effect.CreateEffect(sc)
    e1:SetType(EFFECT_TYPE_SINGLE)
    if rc:IsType(TYPE_XYZ) then
        e1:SetCode(EFFECT_CHANGE_RANK)
    else
        e1:SetCode(EFFECT_CHANGE_LEVEL)
    end
    e1:SetValue(lv)
    rc:RegisterEffect(e1)
    rc:ChangeBaseDif(dif)
end

function Card.ChangeBaseDif(rc,dif)
    local lv=dif
    if dif==nil then return false end
    if Auxiliary.GetValueType(dif)=="string" then
        lv=rc:GetPhiDif(dif)
    end
    rc:ResetFlagEffect(m)
    rc:ResetFlagEffect(m+1)
    if lv<=0 then
        rc:RegisterFlagEffect(m,0,0,1,0)
    elseif lv~=17 then
        rc:RegisterFlagEffect(m,0,EFFECT_FLAG_CLIENT_HINT,1,lv,aux.Stringid(m,lv-1))
    else
        rc:RegisterFlagEffect(m,0,EFFECT_FLAG_CLIENT_HINT,1,lv,aux.Stringid(m+1,0))
    end
    if Auxiliary.GetValueType(dif)=="string" then
        local i
        if dif=="ez" then i=1 end
        if dif=="md" then i=2 end
        if dif=="hd" then i=3 end
        if dif=="at" then i=4 end
        if dif=="sp" then i=5 end
        if dif=="le" then i=6 end
        rc:RegisterFlagEffect(m+1,0,EFFECT_FLAG_CLIENT_HINT,1,i,aux.Stringid(m+1,i))
    end
end

function Card.PhiAddData(c)
    if not c:IsSetCard(0x77d) then return false end
    if c:IsType(TYPE_MONSTER) then return false end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_BASE_DEFENSE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetReset(RESET_EVENT+0xb7c0000)
    e1:SetValue(c:GetPhi("def"))
    c:RegisterEffect(e1,true)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CHANGE_RACE)
    e2:SetValue(c:GetPhi("race"))
    c:RegisterEffect(e2,true)
    local e3=e1:Clone()
    e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
    e3:SetValue(c:GetPhi("att"))
    c:RegisterEffect(e3,true)
    local e4=e1:Clone()
    e4:SetCode(EFFECT_SET_BASE_ATTACK)
    e4:SetValue(c:GetPhi("atk"))
    c:RegisterEffect(e4,true)
    local e5=e1:Clone()
    e5:SetCode(EFFECT_CHANGE_TYPE)
    e5:SetValue(c:GetPhi("type"))
    c:RegisterEffect(e5,true)
    local e6=e1:Clone()
    e6:SetCode(EFFECT_CHANGE_LEVEL)
    e6:SetValue(c:GetFlagEffectLabel(m))
    c:RegisterEffect(e6,true)
end

function Group.PhiAddData(g)
    local tc=g:GetFirst()
    while tc do
        Card.PhiAddData(tc)
        tc=g:GetNext()
    end
end

function phi.Initialize(c,f)
    if f==nil then f=phi.operation end
    local k=c:GetCode()
    local ge1=Effect.CreateEffect(c)
    ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    ge1:SetProperty(EFFECT_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    ge1:SetCode(EVENT_PREDRAW)
    ge1:SetCountLimit(1,k+EFFECT_COUNT_CODE_DUEL)
    ge1:SetOperation(f)
    Duel.RegisterEffect(ge1,0)
end

function phi.operation(e)
    local c=e:GetHandler()
    local tp=c:GetControler()
    local g=Duel.GetMatchingGroup(Card.IsCode,tp,0xff,0,nil,c:GetCode())
    local tc=g:GetFirst()
    while tc do
        Card.ChangeBaseDif(tc,"ez")
        tc=g:GetNext()
    end
end

function phi.mdoperation(e)
    local c=e:GetHandler()
    local tp=c:GetControler()
    local g=Duel.GetMatchingGroup(Card.IsCode,tp,0xff,0,nil,c:GetCode())
    local tc=g:GetFirst()
    while tc do
        Card.ChangeBaseDif(tc,"md")
        tc=g:GetNext()
    end
end

function phi.hdoperation(e)
    local c=e:GetHandler()
    local tp=c:GetControler()
    local g=Duel.GetMatchingGroup(Card.IsCode,tp,0xff,0,nil,c:GetCode())
    local tc=g:GetFirst()
    while tc do
        Card.ChangeBaseDif(tc,"hd")
        tc=g:GetNext()
    end
end

function phi.spoperation(e)
    local c=e:GetHandler()
    local tp=c:GetControler()
    local g=Duel.GetMatchingGroup(Card.IsCode,tp,0xff,0,nil,c:GetCode())
    local tc=g:GetFirst()
    while tc do
        Card.ChangeBaseDif(tc,"sp")
        tc=g:GetNext()
    end
end

function phi.leoperation(e)
    local c=e:GetHandler()
    local tp=c:GetControler()
    local g=Duel.GetMatchingGroup(Card.IsCode,tp,0xff,0,nil,c:GetCode())
    local tc=g:GetFirst()
    while tc do
        Card.ChangeBaseDif(tc,"le")
        tc=g:GetNext()
    end
end

function phi.ChangePoint(c,code,f,etype,fcon)
    if code==EVENT_CHAINING then
        if fcon==nil then
            fcon=phi.lvcon
        end
        etype=EFFECT_TYPE_FIELD
    end
    if etype==nil then etype=EFFECT_TYPE_SINGLE end
    if fcon==nil then fcon=aux.TRUE end
    local ge1=Effect.CreateEffect(c)
    ge1:SetType(etype+EFFECT_TYPE_CONTINUOUS)
    ge1:SetProperty(EFFECT_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    ge1:SetCode(code)
    ge1:SetRange(0x3ff)
    ge1:SetCondition(fcon)
    ge1:SetOperation(f)
    c:RegisterEffect(ge1)
end

function phi.lvcon(e,tp,eg,ep,ev,re,r,rp)
    return re:GetHandler()==e:GetHandler()
end

function Card.LevelCompareDif(c)
    local i
    local dif=c:GetFlagEffectLabel(m+1)
    if dif<4 then
        if dif==3 and c:GetPhiDif(4)==0 then i=3
        else i=dif+1 end
    elseif dif==4 then i=4
    else return nil end
    if i==dif then return nil end
    if i==1 then return "ez" end
    if i==2 then return "md" end
    if i==3 then return "hd" end
    if i==4 then return "at" end
end

function Card.ChangeDif(c,ck,sc)
    if sc==nil then sc=c end
    c:ChangeBaseDif(ck)
    c:SetLevel(ck,sc)
    return true
end

function phi.lvchange(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ck=c:LevelCompareDif()
    c:ChangeDif(ck)
end

function Effect.LevelCondition(e,ck)
    local c=e:GetHandler()
    if c:GetFlagEffectLabel(m)==nil and c:GetFlagEffectLabel(m+1)==nil then return false end
    if ck==nil then
        if c:GetFlagEffectLabel(m)==nil then
            return false
        else
            return c:GetFlagEffectLabel(m)>=e:GetLabel()
        end
    elseif c:GetFlagEffectLabel(m+1)==nil then
        return false
    else
        return c:GetFlagEffectLabel(m+1)==ck
    end
end

function phi.basecon(e,tp,eg,ep,ev,re,r,rp)
    return e:LevelCondition()
end

function phi.spbasecon(e,tp,eg,ep,ev,re,r,rp)
    return e:LevelCondition(5)
end

function phi.lebasecon(e,tp,eg,ep,ev,re,r,rp)
    return e:LevelCondition(6)
end

function Card.GeiPhiDifMax(c)
    local k=math.max(c:GetPhiDif("ez"),c:GetPhiDif("md"),c:GetPhiDif("hd"),c:GetPhiDif("at"),c:GetPhiDif("sp"),c:GetPhiDif("le"))
    return k
end

function Effect.PhiHintMsg(e,dif,code,tp)
    if code==nil then code=e:GetHandler():GetCode() end
    if tp==nil then tp=e:GetHandlerPlayer() end
    if Auxiliary.GetValueType(dif)=="string" then
        if dif=="ce0" then dif=8 end
        if dif=="ce1" then dif=9 end
        if dif=="ez" then dif=10 end
        if dif=="md" then dif=11 end
        if dif=="hd" then dif=12 end
        if dif=="at" then dif=13 end
        if dif=="sp" then dif=14 end
        if dif=="le" then dif=15 end
    end
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(code,dif))
end

function Effect.PhiSetDescription(e,code,dif)
    if Auxiliary.GetValueType(dif)=="string" then
        if dif=="ce0" then dif=8 end
        if dif=="ce1" then dif=9 end
        if dif=="ez" then dif=10 end
        if dif=="md" then dif=11 end
        if dif=="hd" then dif=12 end
        if dif=="at" then dif=13 end
        if dif=="sp" then dif=14 end
        if dif=="le" then dif=15 end
    end
    e:SetDescription(aux.Stringid(code,dif))
end

function Card.GetLinkMarker(c)
    if not c:IsType(TYPE_LINK) then return false end
    local lk=0
    if c:IsLinkMarker(0x001) then lk=lk+0x001 end
    if c:IsLinkMarker(0x002) then lk=lk+0x002 end
    if c:IsLinkMarker(0x004) then lk=lk+0x004 end
    if c:IsLinkMarker(0x008) then lk=lk+0x008 end
    if c:IsLinkMarker(0x020) then lk=lk+0x020 end
    if c:IsLinkMarker(0x040) then lk=lk+0x040 end
    if c:IsLinkMarker(0x080) then lk=lk+0x080 end
    if c:IsLinkMarker(0x100) then lk=lk+0x100 end
    return lk
end

function Card.GetRcSystemPoint(c,tp)
    if not c:IsLocation(0x0c) then return false end
    local point={}
    local cp=c:GetControler()
    if cp==tp then cp=-1 else cp=1 end
    local loc=c:GetLocation()
    local seq=c:GetSequence()
    if loc==LOCATION_MZONE then
        if seq<5 then
            point={(2-seq)*cp,1*cp}
        else
            point={((-2)*seq+11)*cp,0}
        end
    else
        if seq~=5 then
            point={(2-seq)*cp,2*cp}
        else
            point={3*cp,1*cp}
        end
    end
    return point
end

function Duel.GetRcSystemPoint(tp,cp,loc,seq)
    local point={}
    if cp==tp then cp=-1 else cp=1 end
    if loc==LOCATION_MZONE then
        if seq<5 then
            point={(2-seq)*cp,1*cp}
        else
            point={((-2)*seq+11)*cp,0}
        end
    else
        if seq~=5 then
            point={(2-seq)*cp,2*cp}
        else
            point={3*cp,1*cp}
        end
    end
    return point
end

function Card.GetLinkMarkerSlope(c)
    if not c:IsType(TYPE_LINK) then return false end
    local slope=0
    --(k=-A/B)
    if c:IsLinkMarker(0x101) then slope=slope+0x1 end --A=-B
    if c:IsLinkMarker(0x082) then slope=slope+0x2 end --A=0
    if c:IsLinkMarker(0x044) then slope=slope+0x4 end --A=B
    if c:IsLinkMarker(0x028) then slope=slope+0x8 end --B=0
    if slope==0 then return false end
    return slope
end

function Card.GetLinkedLine(c,tp)
    if not c:IsType(TYPE_LINK) then return false end
    local line={}
    local point=c:GetRcSystemPoint(tp)
    if not point then return false end
    if c:IsLinkMarker(0x101) then table.insert(line,{1,-1,(point[1]*(-1)+point[2]*(1)),point[1],point[2]}) end
    if c:IsLinkMarker(0x082) then table.insert(line,{1,0,(point[1]*(-1)),point[1],point[2]}) end
    if c:IsLinkMarker(0x044) then table.insert(line,{1,1,(point[1]*(-1)+point[2]*(-1)),point[1],point[2]}) end
    if c:IsLinkMarker(0x028) then table.insert(line,{0,1,(point[2]*(-1)),point[1],point[2]}) end
    return line
end

function Card.GetLinkedHalfLineGroup(c)
    if not c:IsType(TYPE_LINK) then return false end
    local rg=Group.CreateGroup()
    local tp=c:GetControler()
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0x0c,0x0c,c)
    if #g==0 then return rg end
    local line=c:GetLinkedLine(tp)
    if #line==0 then return rg end
    for tc in aux.Next(g) do
        local tpoint=tc:GetRcSystemPoint(tp)
        for i in ipairs(line) do
            if line[i][1]*tpoint[1]+line[i][2]*tpoint[2]+line[i][3]==0 then
                if line[i][1]-line[i][2]==1 then
                    if c:IsLinkMarker(0x080) and tpoint[2]-line[i][5]>0 then rg:AddCard(tc) end
                    if c:IsLinkMarker(0x002) and tpoint[2]-line[i][5]<0 then rg:AddCard(tc) end
                elseif line[i][1]-line[i][2]==-1 then
                    if c:IsLinkMarker(0x020) and tpoint[1]-line[i][4]>0 then rg:AddCard(tc) end
                    if c:IsLinkMarker(0x008) and tpoint[1]-line[i][4]<0 then rg:AddCard(tc) end
                elseif line[i][1]-line[i][2]==2 then
                    if c:IsLinkMarker(0x100) and tpoint[1]-line[i][4]>0 then rg:AddCard(tc) end
                    if c:IsLinkMarker(0x001) and tpoint[1]-line[i][4]<0 then rg:AddCard(tc) end
                elseif line[i][1]-line[i][2]==0 then
                    if c:IsLinkMarker(0x004) and tpoint[1]-line[i][4]>0 then rg:AddCard(tc) end
                    if c:IsLinkMarker(0x040) and tpoint[1]-line[i][4]<0 then rg:AddCard(tc) end
                end
            end
        end
    end
    return rg
end

function Card.GetLinkedLineGroup(c)
    if not c:IsType(TYPE_LINK) then return false end
    local rg=Group.CreateGroup()
    local tp=c:GetControler()
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0x0c,0x0c,c)
    if #g==0 then return rg end
    local line=c:GetLinkedLine(tp)
    if #line==0 then return rg end
    for tc in aux.Next(g) do
        local tpoint=tc:GetRcSystemPoint(tp)
        for i in ipairs(line) do
            if line[i][1]*tpoint[1]+line[i][2]*tpoint[2]+line[i][3]==0 then
                rg:AddCard(tc)
            end
        end
    end
    return rg
end

function Card.GetCardLine(c,tc,tp)
    if c==tc then return false end
    local cpoint=c:GetRcSystemPoint(tp)
    local tcpoint=tc:GetRcSystemPoint(tp)
    local j,k,p,q=cpoint[1],cpoint[2],tcpoint[1],tcpoint[2]
    return {q-k,j-p,k*p-j*q}
end

function Card.GetCardLineGroup(c,tc)
    local rg=Group.CreateGroup()
    if not (c:IsLocation(0x0c) and tc:IsLocation(0x0c)) or c==tc then return rg end
    local cg=Group.FromCards(c,tc)
    local tp=c:GetControler()
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0x0c,0x0c,cg)
    if #g==0 then return rg end
    local line=c:GetCardLine(tc,tp)
    if #line==0 then return rg end
    local j,k,l=line[1],line[2],line[3]
    for rc in aux.Next(g) do
        local tpoint=rc:GetRcSystemPoint(tp)
        local p,q=tpoint[1],tpoint[2]
        if j==0 or k==0 then
            if (j*p+k*q+l)^2<0.25*(j*j+k*k) then rg:AddCard(rc) end
        else
            local spoint={{p-0.5,q-0.5},{p-0.5,q+0.5},{p+0.5,q-0.5},{p+0.5,q+0.5}}
            local zero,posn,negn=0,0,0
            for i in pairs(spoint) do
                local num=j*spoint[i][1]+k*spoint[i][2]+l
                if num==0 then
                    zero=zero+1
                elseif num>0 then
                    posn=posn+1
                else
                    negn=negn+1
                end
            end
            if posn*negn~=0 then rg:AddCard(rc) end
        end
    end
    return rg
end

function Group.GetGroupLineGroup(cg)
    local rg=Group.CreateGroup()
    if #cg~=2 or cg:FilterCount(Card.IsLocation,nil,LOCATION_ONFIELD)~=2 then return rg end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0x0c,0x0c,cg)
    if #g==0 then return rg end
    local c1,c2=cg:GetFirst(),cg:GetNext()
    local tp=c1:GetControler()
    local line=c1:GetCardLine(c2,tp)
    if #line==0 then return rg end
    local j,k,l=line[1],line[2],line[3]
    for rc in aux.Next(g) do
        local tpoint=rc:GetRcSystemPoint(tp)
        local p,q=tpoint[1],tpoint[2]
        if j==0 or k==0 then
            if (j*p+k*q+l)^2<0.25*(j*j+k*k) then rg:AddCard(rc) end
        else
            local spoint={{p-0.5,q-0.5},{p-0.5,q+0.5},{p+0.5,q-0.5},{p+0.5,q+0.5}}
            local zero,posn,negn=0,0,0
            for i in pairs(spoint) do
                local num=j*spoint[i][1]+k*spoint[i][2]+l
                if num==0 then
                    zero=zero+1
                elseif num>0 then
                    posn=posn+1
                else
                    negn=negn+1
                end
            end
            if posn*negn~=0 then rg:AddCard(rc) end
        end
    end
    return rg
end

function Card.GetCrossFieldCard(c,tp)
    if tp==nil then tp=c:GetControler() end
    local g=Duel.GetFieldGroup(tp,0x0c,0x0c)
    local rg=Group.CreateGroup()
    if #g==0 then return rg end
    local point=c:GetRcSystemPoint(tp)
    for tc in aux.Next(g) do
        local tpoint=tc:GetRcSystemPoint(tp)
        if math.abs(tpoint[1]-point[1])+math.abs(tpoint[2]-point[2])<=1 then
            rg:AddCard(tc)
        end
    end
    return rg
end

function Duel.GetCrossFieldCard(tp,cp,loc,seq)
    local g=Duel.GetFieldGroup(tp,0x0c,0x0c)
    local rg=Group.CreateGroup()
    if #g==0 then return rg end
    local point=Duel.GetRcSystemPoint(tp,cp,loc,seq)
    for tc in aux.Next(g) do
        local tpoint=tc:GetRcSystemPoint(tp)
        if math.abs(tpoint[1]-point[1])+math.abs(tpoint[2]-point[2])<=1 then
            rg:AddCard(tc)
        end
    end
    return rg
end

local j,k=0,1
print(math.cos(math.atan(-j,k)))