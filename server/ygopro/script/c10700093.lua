--我,不是说了能力要平均值么! 阿黛尔·冯·阿斯卡姆
local m=10700093
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
    --atk
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_SET_BASE_ATTACK)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(cm.adval)
	c:RegisterEffect(e6)
    --spsummonsuccess
    local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,m)
    e1:SetCondition(cm.drcon)
	e1:SetTarget(cm.drtg)
	e1:SetOperation(cm.drop)
	c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
    e3:SetCountLimit(1,m+1)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
    if not cm.global_check then
        cm.global_check=true
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
        e1:SetCode(EVENT_ADJUST)
        e1:SetOperation(cm.adopsp)
        Duel.RegisterEffect(e1,0)
        local e2=e1:Clone()
        e2:SetCode(EVENT_SPSUMMON_SUCCESS)
        Duel.RegisterEffect(e2,0)
    end
end

function cm.lcheck(g,lc)
	return g:IsExists(Card.IsLinkAttribute,1,nil,ATTRIBUTE_DIVINE) or g:IsExists(Card.IsLinkRace,1,nil,RACE_SPELLCASTER)
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

function cm.spafilter(c)
    return c:IsFaceup() and c:GetAttack()>0 and not c:IsCode(m)
end

function cm.adopsp(e)
    local tp=e:GetOwnerPlayer()
    if Duel.GetFlagEffect(tp,m)==0 then
        Duel.RegisterFlagEffect(tp,m,0,0,1,0)
        Duel.RegisterFlagEffect(1-tp,m,0,0,1,0)
    end
    local g=Duel.GetMatchingGroup(cm.spafilter,tp,0x04,0x04,nil)
    if #g==0 then return false end
    for tc in aux.Next(g) do
        local atk=tc:GetAttack()
        if atk>Duel.GetFlagEffectLabel(tp,m) then
            Duel.ResetFlagEffect(tp,m)
            Duel.ResetFlagEffect(1-tp,m)
            Duel.RegisterFlagEffect(tp,m,0,0,1,atk)
            Duel.RegisterFlagEffect(1-tp,m,0,0,1,atk)
        end
    end
end

function cm.adval(e,c)
	return Duel.GetFlagEffectLabel(e:GetOwnerPlayer(),m)//2
end

function cm.condfilter(c)
    return c:IsAttribute(ATTRIBUTE_DIVINE) and not c:IsCode(m)
end

function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.condfilter,1,nil)
end

function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function cm.drop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return false end
    if Duel.Draw(tp,1,REASON_EFFECT) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetRange(LOCATION_MZONE)
        e1:SetValue(1000)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        c:RegisterEffect(e1)
    end
end

function cm.thtfilter(c)
    return c:IsAbleToHand() and c:IsAttribute(ATTRIBUTE_DIVINE) and not c:IsCode(m)
end

function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsLocation(0x10) and cm.thtfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.thtfilter,tp,0x10,0x10,1,nil) and c:IsAbleToHand() end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,cm.thtfilter,tp,0x10,0x10,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,nil,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,nil,nil)
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not (c:IsRelateToEffect(e) and tc:IsRelateToEffect(e)) then return false end
    if Duel.SendtoDeck(c,nil,2,REASON_EFFECT) then
        Duel.SendtoHand(tc,tp,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tc)
    end
end