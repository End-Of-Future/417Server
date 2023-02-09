--激流之潮
function c27822005.initial_effect(c)
	c:SetUniqueOnField(1,0,27822005)   
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN)   
	e1:SetOperation(c27822005.acop) 
	c:RegisterEffect(e1)  
	--xx
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_REMOVE) 
	e2:SetRange(LOCATION_SZONE) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCondition(c27822005.xxcon) 
	e2:SetTarget(c27822005.xxtg) 
	e2:SetOperation(c27822005.xxop) 
	c:RegisterEffect(e2) 
end 
c27822005.XXSplash=true 
function c27822005.tgfil(c) 
	return c:IsAbleToGrave() and c.XXSplash  
end 
function c27822005.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c27822005.tgfil,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(27822005,0)) then 
	local dg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(dg,nil,2,REASON_EFFECT) 
	Duel.BreakEffect() 
	local sg=Duel.SelectMatchingCard(tp,c27822005.tgfil,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(sg,REASON_EFFECT) 
	end 
end 
function c27822005.xckfil(c,tp) 
	return c:IsControler(tp) and c:IsType(TYPE_MONSTER) and c.XXSplash   
end 
function c27822005.xxcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(c27822005.xckfil,1,nil,tp) 
end 
function c27822005.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c.XXSplash 
end 
function c27822005.xxtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFlagEffect(tp,27822005)==0 and Duel.IsExistingMatchingCard(c27822005.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) 
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFlagEffect(tp,17822005)==0 and Duel.IsPlayerCanSpecialSummonMonster(tp,27822030,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_AQUA,ATTRIBUTE_WATER,POS_FACEUP_DEFENSE)
	if chk==0 then return b1 or b2 end  
	if b1 and b2 then 
	op=Duel.SelectOption(tp,aux.Stringid(27822005,1),aux.Stringid(27822005,2)) 
	elseif b1 then 
	op=Duel.SelectOption(tp,aux.Stringid(27822005,1))
	elseif b2 then 
	op=Duel.SelectOption(tp,aux.Stringid(27822005,2))+1 
	end 
	e:SetLabel(op)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0) 
end 
function c27822005.xxop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local op=e:GetLabel() 
	local g=Duel.GetMatchingGroup(c27822005.spfil,tp,LOCATION_HAND,0,nil,e,tp) 
	if op==0 and g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	Duel.RegisterFlagEffect(tp,27822005,RESET_PHASE+PHASE_END,0,1)
	elseif op==1 and Duel.IsPlayerCanSpecialSummonMonster(tp,27822030,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_AQUA,ATTRIBUTE_WATER,POS_FACEUP_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local token=Duel.CreateToken(tp,27822030) 
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE) 
	Duel.RegisterFlagEffect(tp,17822005,RESET_PHASE+PHASE_END,0,1)
	end 
end 







