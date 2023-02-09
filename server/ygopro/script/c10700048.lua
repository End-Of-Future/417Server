--業·古手梨花
local m=10700048
local cm=_G["c"..m]

function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,cm.lcheck)
	c:EnableReviveLimit()
    --imm
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_CANNOT_REMOVE)
    e3:SetValue(POS_FACEDOWN)
    c:RegisterEffect(e3)
    --refresh
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_REMOVE+CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,m)
    e4:SetCondition(cm.thcon)
	e4:SetTarget(cm.thtg)
	e4:SetOperation(cm.thop)
	c:RegisterEffect(e4)
    --todeck
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE+CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,m+1)
	e5:SetTarget(cm.tdtg)
	e5:SetOperation(cm.tdop)
	c:RegisterEffect(e5)
    --atklimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(cm.atkcon)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)
end

function cm.lcfilter(c)
    return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_FIEND)
end

function cm.lcheck(g)
	return g:IsExists(cm.lcfilter,1,nil)
end

function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end

function cm.tgthfilter(c)
    return c:IsAbleToRemove(tp,POS_FACEDOWN) and c:IsFaceup()
end

function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(cm.tgthfilter,tp,0x01,0x01,nil)
    if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,nil,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,nil,LOCATION_REMOVED)
end

function cm.optdfilter(c)
    return (not c:IsLocation(LOCATION_DECK)) and c:IsAbleToDeck()
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tgthfilter,tp,0x01,0x01,nil)
    if #g>0 and Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT) and g:FilterCount(cm.optdfilter,nil)>0 then
        Duel.BreakEffect()
        Duel.SendtoDeck(g:Filter(cm.optdfilter,nil),nil,2,REASON_EFFECT)
    end
end

function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(Card.IsAbleToHandAsCost,tp,0x20,0x20,nil)
	if chk==0 then return #g>0 end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,nil,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,nil,LOCATION_HAND)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,nil,LOCATION_HAND)
end

function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsAbleToHandAsCost,tp,0x20,0x20,nil)
    if #g<=0 then return false end
    local rg=g:RandomSelect(tp,1)
    local rc=rg:GetFirst()
    local rpos=rc:GetPosition()
    Duel.HintSelection(rg)
    if Duel.SendtoHand(rc,tp,REASON_EFFECT) then
        Duel.ConfirmCards(1-tp,rc)
        Duel.BreakEffect()
        if rpos==POS_FACEUP then
            if rc:IsAbleToRemove(tp,POS_FACEDOWN) then
                Duel.Remove(rc,POS_FACEDOWN,REASON_EFFECT)
            else
                Duel.SendtoDeck(rc,tp,2,REASON_EFFECT)
            end
        elseif rpos==POS_FACEDOWN then
            Duel.SendtoDeck(rc,nil,2,REASON_EFFECT)
        end
    end
end

function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetHandler():GetSummonLocation()==LOCATION_REMOVED
end

function cm.atkval(e,c)
    local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(Card.IsFacedown,tp,0x01,0,nil)*100
end