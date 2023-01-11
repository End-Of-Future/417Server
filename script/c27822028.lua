--激流回涌
function c27822028.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,27822028)
	e1:SetTarget(c27822028.sptg)
	e1:SetOperation(c27822028.spop)
	c:RegisterEffect(e1) 
	--to deck 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TODECK) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_TO_GRAVE) 
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET) 
	e2:SetCountLimit(1,17822028) 
	e2:SetCondition(c27822028.tdcon)
	e2:SetCost(aux.bfgcost) 
	e2:SetTarget(c27822028.tdtg) 
	e2:SetOperation(c27822028.tdop) 
	c:RegisterEffect(e2) 
end 
c27822028.XXSplash=true 
function c27822028.spfil(c,e,tp)
	return c.XXSplash and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c27822028.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c27822028.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c27822028.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c27822028.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end 
function c27822028.tckfil(c,tp) 
	return c:IsType(TYPE_MONSTER) and c:IsControler(tp) and c.XXSplash  
end 
function c27822028.tdcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(c27822028.tckfil,1,nil,tp) 
end  
function c27822028.tdfil(c) 
	return c:IsType(TYPE_LINK) and c:IsAbleToDeck() 
end 
function c27822028.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return Duel.IsExistingTarget(c27822028.tdfil,tp,LOCATION_GRAVE,0,1,nil) end 
	local g=Duel.SelectTarget(tp,c27822028.tdfil,tp,LOCATION_GRAVE,0,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end  
function c27822028.tdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT) 
	end 
end 
 






