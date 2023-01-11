--奇正相生
local m=10703015
local cm=_G["c"..m]

function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE+CATEGORY_TOHAND+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(cm.condition)
    e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
    local e3=e1:Clone()
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_INACTIVATE)
	e3:SetCondition(cm.condition2)
	c:RegisterEffect(e3)
end

function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(Card.IsCode,tp,0x04,0,1,nil,10703012)
end

function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(Card.IsCode,tp,0x04,0,1,nil,10703012)
end

function cm.chainlm(e,ep,tp)
	return tp==ep
end

function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,0x04,1,1,nil)
    if Duel.IsExistingMatchingCard(Card.IsCode,tp,0x04,0,1,nil,10703012) then
        Duel.SetChainLimit(cm.chainlm)
    end
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,1-tp,0)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,2000)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,0x02)
end

function cm.opdfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDiscardable()
end

function cm.opafilter(c,e)
    return not c:IsImmuneToEffect(e)
end

function cm.desop(e,tp,eg,ep,ev,re,r,rp)
    local i=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
    local tc=nil
    if Duel.IsExistingMatchingCard(cm.opdfilter,tp,0,0x02,1,nil) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISCARD)
        local g=Duel.SelectMatchingCard(1-tp,cm.opdfilter,tp,0,0x02,1,1,nil)
        tc=g:GetFirst()
        if tc then
            Duel.SendtoGrave(tc,REASON_EFFECT+REASON_DISCARD)
        end
    end
    Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,i+2))
    Duel.BreakEffect()
    if i==0 and (tc==nil or not tc:IsType(TYPE_SPELL)) then
        local gc=Duel.GetFirstTarget()
        if gc:IsRelateToEffect(e) and Duel.Destroy(gc,REASON_EFFECT) then
            Duel.Damage(1-tp,2000,REASON_EFFECT)
        end
    elseif i==1 and (tc==nil or not tc:IsType(TYPE_TRAP)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g1=Duel.SelectMatchingCard(tp,cm.opafilter,tp,0,0x0a,1,1,nil,e)
        if #g1>0 then
            Duel.SendtoHand(g1,tp,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g1)
            Duel.ShuffleHand(1-tp)
        end
    end
end