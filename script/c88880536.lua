--王牌竞赛 穷奇
function c88880536.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xd88),8,2,c88880536.ovfilter,aux.Stringid(88880536,0))
	c:EnableReviveLimit()		  
	--to deck 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TODECK) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,88880536) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) end)
	e1:SetTarget(c88880536.tdtg) 
	e1:SetOperation(c88880536.tdop) 
	c:RegisterEffect(e1) 
	--atk 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1,18880536)
	e2:SetCost(c88880536.atkcost) 
	e2:SetTarget(c88880536.atktg) 
	e2:SetOperation(c88880536.atkop) 
	c:RegisterEffect(e2) 
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1) 
	e3:SetCondition(function(e) 
	local mg=e:GetHandler():GetOverlayGroup()
	return mg:GetCount()==mg:FilterCount(function(c) return c:IsSetCard(0xd88) and c:IsType(TYPE_MONSTER) end,1,nil) end)
	c:RegisterEffect(e3)
end
function c88880536.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd88) and c:IsType(TYPE_XYZ) and c:IsRank(6)
end
function c88880536.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end 
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil) 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0) 
end 
function c88880536.tdop(e,tp,eg,ep,ev,re,r,rp)	
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)  
	if g:GetCount()>0 then 
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT) 
	end 
end 
function c88880536.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c88880536.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end 
end 
function c88880536.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()   
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,nil) 
	if c:IsRelateToEffect(e) and g:GetCount()>0 then 
		local atk=g:GetSum(Card.GetAttack) 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1) 
	end 
end 
  









