--辉夜大小姐想让我告白 伊井野弥子
local m=10700551
local cm=_G["c"..m]

function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,cm.lcheck)
    c:EnableReviveLimit()
    --splimit
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(cm.regcon)
	e0:SetOperation(cm.regop)
	c:RegisterEffect(e0)
    --
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_RELEASE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1,m+1)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,m)
    e1:SetCost(cm.recost)
	e1:SetTarget(cm.retg)
	e1:SetOperation(cm.reop)
	c:RegisterEffect(e1)
end

function cm.lckfilter(c)
    return c:IsLinkRace(RACE_FIEND) or c:IsLinkAttribute(ATTRIBUTE_WATER)
end

function cm.lcheck(g,lc)
	return g:IsExists(cm.lckfilter,1,nil)
end

function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end

function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp)
end

function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(m) and bit.band(sumtype,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end

function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(0x04) and chkc:IsLink(2) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsLink,tp,0x04,0,1,nil,2) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g=Duel.SelectTarget(tp,Card.IsLink,tp,0x04,0,1,1,nil,2)
end

function cm.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) then
        local reset=1
        if Duel.GetCurrentPhase()<=PHASE_STANDBY then reset=2 end
        tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,EFFECT_FLAG_CLIENT_HINT,reset,0,aux.Stringid(m,0))
        c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,0,reset,1)
        local g=Group.FromCards(c,tc)
        g:KeepAlive()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
        e1:SetCountLimit(1)
        e1:SetLabel(Duel.GetTurnCount())
        e1:SetLabelObject(g)
        e1:SetCondition(cm.spcon)
        e1:SetOperation(cm.spop)
        e1:SetReset(RESET_PHASE+PHASE_STANDBY,reset)
        Duel.RegisterEffect(e1,tp)
    end
end

function cm.spfilter(c)
	return c:GetFlagEffect(m)~=0 and c:IsAbleToDeck()
end

function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==e:GetLabel()+1 and e:GetLabelObject():FilterCount(cm.spfilter,nil)==2
end

function cm.spofilter(c)
	return c:GetFlagEffectLabel(m)==1
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
    local g=e:GetLabelObject()
    local c=g:Filter(cm.spofilter,nil):GetFirst()
    local tc=g:Filter(aux.TRUE,c):GetFirst()
    if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)==2 then
        if Duel.IsPlayerCanSpecialSummonCount(tp,2) and not Duel.IsPlayerAffectedByEffect(tp,59822133) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,tc)>0 and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
            Duel.AdjustAll()
            if c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
                for rc in aux.Next(g) do
                    --immune
                    local e1=Effect.CreateEffect(c)
                    e1:SetType(EFFECT_TYPE_SINGLE)
                    e1:SetCode(EFFECT_IMMUNE_EFFECT)
                    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
                    e1:SetRange(LOCATION_MZONE)
                    e1:SetValue(cm.efilter)
                    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
                    rc:RegisterEffect(e1,true)
                    local e2=Effect.CreateEffect(c)
                    e2:SetType(EFFECT_TYPE_SINGLE)
                    e2:SetCode(EFFECT_UPDATE_ATTACK)
                    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
                    e2:SetRange(LOCATION_MZONE)
                    e2:SetValue(1000)
                    e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
                    rc:RegisterEffect(e2,true)
                end
            end
        end
    end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetTarget(cm.sumlimit)
    e1:SetReset(RESET_PHASE+PHASE_END,2)
    Duel.RegisterEffect(e1,tp)
    local e4=e1:Clone()
    e4:SetCode(EFFECT_CANNOT_ACTIVATE)
    e4:SetValue(cm.aclimit)
    Duel.RegisterEffect(e4,tp)
end

function cm.efilter(e,te)
	return e:GetHandler()~=te:GetHandler()
end

function cm.sumlimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not (c:IsType(TYPE_LINK) and c:IsLinkBelow(3))
end

function cm.aclimit(e,re,tp)
    local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc:IsSummonLocation(LOCATION_EXTRA) and not rc:IsType(TYPE_LINK)
end

function cm.costrfilter(c,tp)
    return c:IsAbleToRemoveAsCost(tp,POS_FACEDOWN) and c:IsRace(RACE_FIEND)
end

function cm.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costrfilter,tp,0x01,0,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,cm.costrfilter,tp,0x01,0,1,1,nil,tp)
    if Duel.Remove(g,POS_FACEDOWN,REASON_COST) then
        Duel.ConfirmCards(1-tp,g)
    end
end

function cm.tgrfilter(c)
    return c:IsRace(RACE_FIEND) and c:IsFaceup() and not c:IsCode(m)
end

function cm.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(0x04) and cm.tgrfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tgrfilter,tp,0x04,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,cm.tgrfilter,tp,0x04,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end

function cm.reop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetDescription(aux.Stringid(m,1))
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
        e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
        e1:SetRange(LOCATION_MZONE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
        tc:RegisterEffect(e1)
        Duel.Recover(tp,500,REASON_EFFECT)
    end
end