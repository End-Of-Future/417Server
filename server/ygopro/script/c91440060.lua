--NaN·Guardian[M]
local m=91440060
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1165)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
    e1:SetCondition(cm.xcon)
    e1:SetTarget(cm.xtg)
    e1:SetOperation(cm.xop)
    e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,m)
    e2:SetCost(cm.spcost)
    e2:SetTarget(cm.sptg)
    e2:SetOperation(cm.spop)
    c:RegisterEffect(e2)
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.indtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function cm.getcard(p,seq)
    local tc=Duel.GetFieldGroup(p,LOCATION_MZONE,0):Filter(function (c)
        return c:GetSequence()==seq
    end,nil)
    if tc:GetCount()==0 then return nil
    else return tc:GetFirst()
    end
end
function cm.xfilter1(tc,e,tp)
    return tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and tc:IsCode(91440061)
end
function cm.xfilter2(tc,e,tp)
    return tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and tc:IsCode(91440062)
end
function cm.orufilter0(tc,seq,tp,...)
    if tc==nil then return true end
    local tc2=cm.getcard(tp,seq)
    if seq==nil or tc2==nil then
        local para={...}
        for _,v in ipairs(para) do
            if tc==v then return false end
        end
        return tc:IsFaceup() and tc:IsLevel(8) and tc:IsCanOverlay()
    else
        return tc:IsFaceup() and tc:IsLevel(8) and tc:IsCanOverlay() and tc:GetSequence()==seq
    end
end
function cm.orufilter1(c,tp)
    local v=aux.GetColumn(c,tp)
    return (not(v==0 or v==4) and cm.orufilter0(c))--self
    and (cm.orufilter0(Duel.GetFieldCard(tp,LOCATION_MZONE,v-1)))--left
    and (cm.orufilter0(Duel.GetFieldCard(tp,LOCATION_MZONE,v+1)))--right
end
function cm.CheckLocation(tp,loc,seq,g)
    local tc=cm.getcard(tp,seq)
    if tc==nil then return true end
    if g:IsContains(tc) then return true end
    return false
end
function cm.xcon(e,c,og,min,max)
    if c==nil then return true end
    if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
    return Duel.CheckXyzMaterial(c,nil,8,3,3,og)
end
function cm.xtg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
    if og and not min then
        return true
    end
    local minc=3
    local maxc=3
    if min then
        if min>minc then minc=min end
        if max<maxc then maxc=max end
    end
    Duel.Hint(HINT_SELECTMSG,tp,16*m)
    local tc1=Duel.SelectMatchingCard(tp,cm.orufilter1,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
    local seq=aux.GetColumn(tc1,tp)
    Duel.Hint(HINT_SELECTMSG,tp,16*m+1)
    local tc2=Duel.SelectMatchingCard(tp,cm.orufilter0,tp,LOCATION_MZONE,0,1,1,nil,seq-1,tp,tc1,cm.getcard(tp,seq+1)):GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,16*m+2)
    local tc3=Duel.SelectMatchingCard(tp,cm.orufilter0,tp,LOCATION_MZONE,0,1,1,nil,seq+1,tp,tc1,tc2):GetFirst()
    local g=Group.FromCards(tc1,tc2,tc3)
    if g then
        g:KeepAlive()
        e:SetLabelObject(g)
        return true
    else return false end
end
function cm.xop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
    --oru
    local mg=e:GetLabelObject()
    local sg=Group.CreateGroup()
    local tc=mg:GetFirst()
    while tc do
        local sg1=tc:GetOverlayGroup()
        sg:Merge(sg1)
        tc=mg:GetNext()
    end
    Duel.SendtoGrave(sg,REASON_RULE)
    c:SetMaterial(mg)
    Duel.Overlay(c,mg)
    --zone
    local zone=0
    if cm.CheckLocation(tp,LOCATION_MZONE,0,mg) and cm.CheckLocation(tp,LOCATION_MZONE,2,mg) then zone=zone+2 end
    if cm.CheckLocation(tp,LOCATION_MZONE,1,mg) and cm.CheckLocation(tp,LOCATION_MZONE,3,mg) then zone=zone+4 end
    if cm.CheckLocation(tp,LOCATION_MZONE,2,mg) and cm.CheckLocation(tp,LOCATION_MZONE,4,mg) then zone=zone+8 end
    --self spsummon
    Duel.SpecialSummonStep(c,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP,zone)
    zone=c:GetSequence()
    --other spsummon
    local tc1=Duel.SelectMatchingCard(tp,cm.xfilter1,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
    Duel.SpecialSummonStep(tc1,SUMMON_TYPE_SPECIAL,tp,tp,true,true,POS_FACEUP,(1<<zone)/2)
    local tc2=Duel.SelectMatchingCard(tp,cm.xfilter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
    Duel.SpecialSummonStep(tc2,SUMMON_TYPE_SPECIAL,tp,tp,true,true,POS_FACEUP,(1<<zone)*2)
    Duel.SpecialSummonComplete()
    mg:DeleteGroup()
end
function cm.spfilter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevel(8)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    if tc then
        Duel.SpecialSummon(tc,SUMMON_TYPE_SPECIAL,tp,tp,false,false,POS_FACEUP)
    end
end
function cm.indtg(e,c)
    return c:IsLevel(8) or c:IsRank(8) or c:IsLink(8)
end
