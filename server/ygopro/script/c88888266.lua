--天与海的誓言·SP梦
local m = 88888266
local cm = _G["c"..m]
function cm.initial_effect(c)
    c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--attack redirect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_PATRICIAN_OF_DARKNESS)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCondition(cm.podcond)
	e2:SetTargetRange(0,1)
	c:RegisterEffect(e2)
	--todeck
	local e3=Effect.CreateEffect(c)
    e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e3:SetCategory(CATEGORY_TODECK)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetCondition(cm.tdcon)
	e3:SetOperation(cm.tdop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
    e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.con)
	e4:SetOperation(cm.op)
	c:RegisterEffect(e4)
end
function cm.rfilter(c)
	return c:IsLevelAbove(1) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function cm.fselect(g,tp)
	return g:GetSum(Card.GetLevel)==7 and aux.mzctcheck(g,tp)
end
function cm.gcheck(g)
	return g:GetSum(Card.GetLevel)<=7
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.rfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	aux.GCheckAdditional=cm.gcheck
	if chk==0 then
		local res=g:CheckSubGroup(cm.fselect,1,g:GetCount(),tp)
		aux.GCheckAdditional=nil
		return res
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g:SelectSubGroup(tp,cm.fselect,false,1,g:GetCount(),tp)
	aux.GCheckAdditional=nil
	Duel.Release(rg,REASON_COST)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
	end
end
function cm.podfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsFaceup() and not c:IsCode(m)
end
function cm.podcond(e)
	local tp=e:GetOwnerPlayer()
	return Duel.IsExistingMatchingCard(cm.podfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_MZONE,0,nil)
	local c=e:GetHandler()
	if aux.NecroValleyNegateCheck(g) then return end
	Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
	Duel.SendtoDeck(c,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) and tc:IsCode(m)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    if Duel.SelectOption(tp,aux.Stringid(m,1)) and Duel.SelectOption(1-tp,aux.Stringid(m,1)) then
        Duel.SelectOption(tp,aux.Stringid(m,2))
        Duel.SelectOption(1-tp,aux.Stringid(m,2))
    end
end